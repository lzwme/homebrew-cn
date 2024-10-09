class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.10.0",
      revision: "234f711a6cc91012a6e0afa6a64dabf87f6e4dcc"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a0c9e9ce88525ca67368f4c13ac600ded14a66d55915d1fa864b719a1e5fff4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a0c9e9ce88525ca67368f4c13ac600ded14a66d55915d1fa864b719a1e5fff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a0c9e9ce88525ca67368f4c13ac600ded14a66d55915d1fa864b719a1e5fff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f68fecd4abe6c25d6dd485b0c46afa47b226bea43f76ac0f527970cf38ddd79"
    sha256 cellar: :any_skip_relocation, ventura:       "2f68fecd4abe6c25d6dd485b0c46afa47b226bea43f76ac0f527970cf38ddd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a0c9e9ce88525ca67368f4c13ac600ded14a66d55915d1fa864b719a1e5fff4"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "installDist"

    libexec.install Dir["buildinstallteku*"]

    (bin"teku").write_env_script libexec"binteku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku", shell_output("#{bin}teku --version")

    rest_port = free_port
    test_args = %W[
      --ee-endpoint=http:127.0.0.1
      --ignore-weak-subjectivity-period-enabled
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false

    ]
    fork do
      exec bin"teku", *test_args
    end
    sleep 15

    output = shell_output("curl -sS -XGET http:127.0.0.1:#{rest_port}ethv1nodesyncing")
    assert_match "is_syncing", output
  end
end