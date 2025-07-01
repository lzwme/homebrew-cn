class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "25.6.0",
      revision: "765e1275ce0da6e495d766ffe8ee52839f2b0beb"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8db2a49e1c7f8c140da359cb2bf27d7c50b2ed43a6586175c60e626e94c3e152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8db2a49e1c7f8c140da359cb2bf27d7c50b2ed43a6586175c60e626e94c3e152"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8db2a49e1c7f8c140da359cb2bf27d7c50b2ed43a6586175c60e626e94c3e152"
    sha256 cellar: :any_skip_relocation, sonoma:        "39026be1d1215036b86f21092050916b1bccfbd2da072eb9e5d9f23b922913e5"
    sha256 cellar: :any_skip_relocation, ventura:       "39026be1d1215036b86f21092050916b1bccfbd2da072eb9e5d9f23b922913e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8db2a49e1c7f8c140da359cb2bf27d7c50b2ed43a6586175c60e626e94c3e152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db2a49e1c7f8c140da359cb2bf27d7c50b2ed43a6586175c60e626e94c3e152"
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