# frozen_string_literal: true

module MidtransApi
  class Errors
    class ResponseError < StandardError; end

    class MovePermanently < ResponseError; end

    class ValidationError < ResponseError; end

    class AccessDenied < ResponseError; end

    class UnauthorizedPayment < ResponseError; end

    class ForbiddenRequest < ResponseError; end

    class NotFound < ResponseError; end

    class HttpNotAllowed < ResponseError; end

    class DuplicateOrderId < ResponseError; end

    class ExpiredTransaction < ResponseError; end

    class WrongDataType < ResponseError; end

    class ManySameCardNumber < ResponseError; end

    class MerchantAccountDeactivated < ResponseError; end

    class ErrorTokenId < ResponseError; end

    class CannotModifyTransaction < ResponseError; end

    class MalformedSyntax < ResponseError; end

    class RefundInvalidAmount < ResponseError; end

    class InternalServerError < ResponseError; end

    class FeatureNotAvailable < ResponseError; end

    class BankConnectionProblem < ResponseError; end

    class PartnerConnectionIssue < ResponseError; end

    class FraudDetectionUnavailable < ResponseError; end

    class PaymentReferenceUnavailable < ResponseError; end

    class UnknownError < ResponseError; end
  end
end
