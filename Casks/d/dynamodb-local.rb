cask "dynamodb-local" do
  version :latest
  sha256 :no_check

  url "https:d1ni2b6xgvw0s0.cloudfront.netv2.xdynamodb_local_latest.tar.gz",
      verified: "d1ni2b6xgvw0s0.cloudfront.net"
  name "Amazon DynamoDB Local"
  desc "Development tool for DynamoDB"
  homepage "https:docs.aws.amazon.comamazondynamodblatestdeveloperguideDynamoDBLocal.html"

  livecheck do
    skip "unversioned command-line application"
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
    depends_on_java "11+"
  end
end