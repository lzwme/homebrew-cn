class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "25.5.0",
      revision: "65869daa82a436b4f27197b3bc7844c88b183ae3"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "871c396722bfabf2438952f629454f3fccac13585184fc1cd4857945a9b04ab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "871c396722bfabf2438952f629454f3fccac13585184fc1cd4857945a9b04ab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "871c396722bfabf2438952f629454f3fccac13585184fc1cd4857945a9b04ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "272f5a65673e04819cc9804432c9861d22509c2f01fc8755d9dc3f137ed2375c"
    sha256 cellar: :any_skip_relocation, ventura:       "272f5a65673e04819cc9804432c9861d22509c2f01fc8755d9dc3f137ed2375c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "871c396722bfabf2438952f629454f3fccac13585184fc1cd4857945a9b04ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "871c396722bfabf2438952f629454f3fccac13585184fc1cd4857945a9b04ab0"
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