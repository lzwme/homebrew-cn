class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "25.3.0",
      revision: "35bf38d7be87fb869a4261d5695c8fe9028b3c3f"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5a940ad5e8bdf0aeea15baa4a564e102bc9c22d53d0dd109a2ead3402e10822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a940ad5e8bdf0aeea15baa4a564e102bc9c22d53d0dd109a2ead3402e10822"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5a940ad5e8bdf0aeea15baa4a564e102bc9c22d53d0dd109a2ead3402e10822"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf63f1d2db7013e7cdb99d7ff8d66f786eb8ec3ee04cfc95cb3244c26c21b7d"
    sha256 cellar: :any_skip_relocation, ventura:       "6bf63f1d2db7013e7cdb99d7ff8d66f786eb8ec3ee04cfc95cb3244c26c21b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a940ad5e8bdf0aeea15baa4a564e102bc9c22d53d0dd109a2ead3402e10822"
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