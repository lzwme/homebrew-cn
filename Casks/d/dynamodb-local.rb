cask "dynamodb-local" do
  version "2025-03-13"
  sha256 "9805d95fe2f5efecfd7f7fec32af8efb32dc83b60a18a2fbd818614ed4b6c6ec"

  url "https:d1ni2b6xgvw0s0.cloudfront.netv2.xdynamodb_local_#{version}.tar.gz",
      verified: "d1ni2b6xgvw0s0.cloudfront.net"
  name "Amazon DynamoDB Local"
  desc "Development tool for DynamoDB"
  homepage "https:docs.aws.amazon.comamazondynamodblatestdeveloperguideDynamoDBLocal.html"

  livecheck do
    url "https:d1ni2b6xgvw0s0.cloudfront.net"
    regex(dynamodb[._-]local[._-]v?(\d+(?:[.-]\d+)+)\.ti)
    strategy :xml do |xml, regex|
      xml.get_elements("ContentsKey").map do |item|
        match = item.text&.strip&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}dynamodb-local.wrapper.sh"
  binary shimscript, target: "dynamodb-local"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      cd "$(dirname "$(readlink -n "${0}")")" && \
        java -Djava.library.path='.DynamoDBLocal_lib' -jar 'DynamoDBLocal.jar' "$@"
    EOS
  end

  # No zap stanza required

  caveats do
    depends_on_java "17+"
  end
end