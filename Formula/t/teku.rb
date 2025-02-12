class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "25.2.0",
      revision: "81802fd6488d378882d029c4936a4788e13fa6d3"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "091c901fac6823c865f4437b482377fca2af3d2dff096b3c883c1160f9bbd7e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091c901fac6823c865f4437b482377fca2af3d2dff096b3c883c1160f9bbd7e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "091c901fac6823c865f4437b482377fca2af3d2dff096b3c883c1160f9bbd7e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "823431ff526da22185d53f4a8f1611f56636732da6ae03d930c2ff138809f314"
    sha256 cellar: :any_skip_relocation, ventura:       "823431ff526da22185d53f4a8f1611f56636732da6ae03d930c2ff138809f314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091c901fac6823c865f4437b482377fca2af3d2dff096b3c883c1160f9bbd7e6"
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