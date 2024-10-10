class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.10.1",
      revision: "29c81b86ff45c1a2eba961488e51df45308b2eeb"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bea813bfa205480b5bdd52f23d8d8ff69adaca60ca3aa9114c76d2224ae9e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bea813bfa205480b5bdd52f23d8d8ff69adaca60ca3aa9114c76d2224ae9e00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bea813bfa205480b5bdd52f23d8d8ff69adaca60ca3aa9114c76d2224ae9e00"
    sha256 cellar: :any_skip_relocation, sonoma:        "210ede5b31f9d5343085549e546116cf37dd51a8a32a1c065276753e5ffd415a"
    sha256 cellar: :any_skip_relocation, ventura:       "210ede5b31f9d5343085549e546116cf37dd51a8a32a1c065276753e5ffd415a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bea813bfa205480b5bdd52f23d8d8ff69adaca60ca3aa9114c76d2224ae9e00"
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