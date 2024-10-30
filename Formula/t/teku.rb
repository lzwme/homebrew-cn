class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.10.3",
      revision: "56440a82e920d81915a4c9b831a4873eff721b13"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "972094785a0359a67d81a0e9f8e28b601df104b89f4a9c661e207426045e4004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972094785a0359a67d81a0e9f8e28b601df104b89f4a9c661e207426045e4004"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "972094785a0359a67d81a0e9f8e28b601df104b89f4a9c661e207426045e4004"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fcee62886dc26440e681755a40fa17d5982ba531d33da024ceda3a6613940a9"
    sha256 cellar: :any_skip_relocation, ventura:       "9fcee62886dc26440e681755a40fa17d5982ba531d33da024ceda3a6613940a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972094785a0359a67d81a0e9f8e28b601df104b89f4a9c661e207426045e4004"
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