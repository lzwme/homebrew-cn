cask "dynamodb-local" do
  version "2025-04-14"
  sha256 "9a8e6c1b1d4f5c1030c00a5a7eaee1a9ab2b8f1bbde7b700d5505898a3948fff"

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