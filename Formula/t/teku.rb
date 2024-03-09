class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.3.0",
      revision: "51807fbf17f15f343a0d84aa9fadaf6dc64c30e5"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8dab6e0b66510f8a10d863ad6cb707c5abe62937f2873c2fe55c22ff5306c50"
    sha256 cellar: :any_skip_relocation, ventura:        "b8dab6e0b66510f8a10d863ad6cb707c5abe62937f2873c2fe55c22ff5306c50"
    sha256 cellar: :any_skip_relocation, monterey:       "b8dab6e0b66510f8a10d863ad6cb707c5abe62937f2873c2fe55c22ff5306c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
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