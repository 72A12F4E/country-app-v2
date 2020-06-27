//
//  Range+Rescale'.swift
//  CountryAppV2
//
//  Created by Blake McAnally on 6/27/20.
//

extension ClosedRange where Bound == Double {
    func rescale(_ value: Bound, to: ClosedRange<Bound>) -> Bound {
        precondition(self.contains(value))
        return (value - lowerBound) / (upperBound - lowerBound) * (to.upperBound - to.lowerBound)
    }
}
