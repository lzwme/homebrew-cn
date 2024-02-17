class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.2.0",
      revision: "b544b9ebe589e78fa2f075ae389b041dc2871ea2"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1a3267a2aa42ccd8ec775d29863b8199dc50c8021199313a0178eaca4195f4c"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a3267a2aa42ccd8ec775d29863b8199dc50c8021199313a0178eaca4195f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a3267a2aa42ccd8ec775d29863b8199dc50c8021199313a0178eaca4195f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
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