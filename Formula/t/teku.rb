class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.6.0",
      revision: "fb21b1a17353949213212626571a26c4acfcf107"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b85c105b821f95c959cfa1151d0710c325ca906a432287d2dc1958cd643dbe68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b85c105b821f95c959cfa1151d0710c325ca906a432287d2dc1958cd643dbe68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b85c105b821f95c959cfa1151d0710c325ca906a432287d2dc1958cd643dbe68"
    sha256 cellar: :any_skip_relocation, sonoma:         "effd737052f361a73b5f35878222f27c36c342a4368d2353d30c5ca4e5d18148"
    sha256 cellar: :any_skip_relocation, ventura:        "effd737052f361a73b5f35878222f27c36c342a4368d2353d30c5ca4e5d18148"
    sha256 cellar: :any_skip_relocation, monterey:       "effd737052f361a73b5f35878222f27c36c342a4368d2353d30c5ca4e5d18148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b068e780e09cc630aafc248827613aa73ae1a69d41f0d5cba5bf6547c0a2374b"
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