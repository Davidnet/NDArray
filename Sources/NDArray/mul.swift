import func CBlas.cblas_saxpy
import func CBlas.cblas_sscal

// extension NDArray where Scalar == Float {
//     public static func * (_ left: NDArray<Float>, _ right: Float) -> NDArray<Float> {
//         var outputData = Array(left.data)

//         cblas_sscal(Int32(left.data.count), right, &outputData, 1)

//         return NDArray(
//             outputData,
//             shape: left.shape
//         )
//     }

//     public static func * (_ left: Float, _ right: NDArray<Float>) -> NDArray<Float> {
//         right * left
//     }

//     public static func * (_ left: NDArray<Float>, _ right: NDArray<Float>) -> NDArray<Float> {
//         precondition(left.shape == right.shape)

//         return NDArray(
//             elementWise(
//                 left.data,
//                 right.data,
//                 apply: *
//             ),
//             shape: left.shape
//         )
//     }
// }