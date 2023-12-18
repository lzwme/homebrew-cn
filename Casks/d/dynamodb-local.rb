cask "dynamodb-local" do
  version :latest
  sha256 :no_check

  url "https:dynamodb-local.s3.amazonaws.comdynamodb_local_latest.tar.gz",
      verified: "dynamodb-local.s3.amazonaws.com"
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
    depends_on_java "6+"
  end
end