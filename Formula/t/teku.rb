class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.12.0",
      revision: "6115f18d1b6529e57076507658deb5ca066dd0ae"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83275d256a75e386ef90938017af302c57ab87861af25407105839c6608a2c12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83275d256a75e386ef90938017af302c57ab87861af25407105839c6608a2c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83275d256a75e386ef90938017af302c57ab87861af25407105839c6608a2c12"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb8168d21fd021d610ac3e94a1278c84aa61b5ec76c01463811fa441e0e1115"
    sha256 cellar: :any_skip_relocation, ventura:       "3eb8168d21fd021d610ac3e94a1278c84aa61b5ec76c01463811fa441e0e1115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83275d256a75e386ef90938017af302c57ab87861af25407105839c6608a2c12"
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