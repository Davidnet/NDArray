// This strategy was taken from TensorFlow
// See: https://github.com/tensorflow/swift-apis/blob/728a2d6c2146d12d8a16428f6c9a3bce24492bb7/Sources/TensorFlow/Core/Tensor.swift#L278

// At first is doesn't seem ideal since it would be nice to enable ExpressibleBy(Int|Float|Bool)Literal to
// be able to write things like x[1, 0...] = 5, however, while this could work in the short-term when NDArray
// is just a struct, it might not work in the future when it might turn into a protocol (to house SparseArray, DenseArray, etc)

@frozen
public struct _NDArrayElementLiteral<Scalar> {
    @usableFromInline let ndarray: NDArray<Scalar>
}

extension _NDArrayElementLiteral: ExpressibleByBooleanLiteral
    where Scalar: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Scalar.BooleanLiteralType
    @inlinable
    public init(booleanLiteral: BooleanLiteralType) {
        ndarray = NDArray(Scalar(booleanLiteral: booleanLiteral))
    }
}

extension _NDArrayElementLiteral: ExpressibleByIntegerLiteral
    where Scalar: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Scalar.IntegerLiteralType
    @inlinable
    public init(integerLiteral: IntegerLiteralType) {
        ndarray = NDArray(Scalar(integerLiteral: integerLiteral))
    }
}

extension _NDArrayElementLiteral: ExpressibleByFloatLiteral
    where Scalar: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Scalar.FloatLiteralType
    @inlinable
    public init(floatLiteral: FloatLiteralType) {
        ndarray = NDArray(Scalar(floatLiteral: floatLiteral))
    }
}

extension _NDArrayElementLiteral: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = _NDArrayElementLiteral<Scalar>
    @inlinable
    public init(arrayLiteral elements: _NDArrayElementLiteral<Scalar>...) {
        let data_array = elements.reduce([Scalar]()) { array, element in
            array + element.ndarray.data.value
        }
        let shape = [elements.count] + elements[0].ndarray.shape

        ndarray = NDArray(data_array, shape: shape)
    }
}

extension NDArray: ExpressibleByArrayLiteral {
    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = _NDArrayElementLiteral<Scalar>

    /// Creates a ndarray initialized with the given elements.
    /// - Note: This is for conversion from ndarray element literals. This is a
    ///   separate method because `ShapedArray` initializers need to call it.
    @inlinable
    internal init(_tensorElementLiterals elements: [_NDArrayElementLiteral<Scalar>]) {
        let data_array = elements.reduce([Scalar]()) { array, element in
            array + element.ndarray.data.value
        }
        let shape = [elements.count] + elements[0].ndarray.shape

        self = NDArray(data_array, shape: shape)
    }

    /// Creates a ndarray initialized with the given elements.
    @inlinable
    public init(arrayLiteral elements: _NDArrayElementLiteral<Scalar>...) {
        precondition(!elements.isEmpty, "Cannot create a 'NDArray' with no elements.")
        self.init(_tensorElementLiterals: elements)
    }
}