class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.6.1",
      revision: "a9f98260452ee1259ec0133d839cf3185396c889"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f77db990232f1f32febaff1bfcb2ce60317a12c0e8b9cbd0e73382b101cbd4d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f77db990232f1f32febaff1bfcb2ce60317a12c0e8b9cbd0e73382b101cbd4d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77db990232f1f32febaff1bfcb2ce60317a12c0e8b9cbd0e73382b101cbd4d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0b8f4fed00317347ca6df49285513eccee3cfa94e3057fed1216d2a43653e65"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b8f4fed00317347ca6df49285513eccee3cfa94e3057fed1216d2a43653e65"
    sha256 cellar: :any_skip_relocation, monterey:       "e0b8f4fed00317347ca6df49285513eccee3cfa94e3057fed1216d2a43653e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632b8206b48965c90bd8b4a0749f28d38477cb7b492e0719fe0e2efc6f19c149"
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