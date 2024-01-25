class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.1.1",
      revision: "da3e51bc874b065925915739e82faaad1ca829b3"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1db865c1c444b0945c1d61e910f2746d46d2da60686ec6e67273542c78876d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1db865c1c444b0945c1d61e910f2746d46d2da60686ec6e67273542c78876d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1db865c1c444b0945c1d61e910f2746d46d2da60686ec6e67273542c78876d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0333d6026b189b763cf52294b08f29d4eed18e1cac16f6892780f5e0dabde2ee"
    sha256 cellar: :any_skip_relocation, ventura:        "0333d6026b189b763cf52294b08f29d4eed18e1cac16f6892780f5e0dabde2ee"
    sha256 cellar: :any_skip_relocation, monterey:       "0333d6026b189b763cf52294b08f29d4eed18e1cac16f6892780f5e0dabde2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1db865c1c444b0945c1d61e910f2746d46d2da60686ec6e67273542c78876d5"
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