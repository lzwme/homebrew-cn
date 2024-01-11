class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https:docs.teku.consensys.net"
  url "https:github.comConsenSysteku.git",
      tag:      "24.1.0",
      revision: "82435a755874b0b1e7cac7bdd89258bb71c7d9fb"
  license "Apache-2.0"
  head "https:github.comConsenSysteku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e217997227a58705d3bdb2999a8b359d93e52c6acbac8a7ff6fcf1efe204a4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e217997227a58705d3bdb2999a8b359d93e52c6acbac8a7ff6fcf1efe204a4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e217997227a58705d3bdb2999a8b359d93e52c6acbac8a7ff6fcf1efe204a4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9b34b9b83ef3b9a877bddb930fd61503345ab56ebf01c8750c953306c43ece2"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b34b9b83ef3b9a877bddb930fd61503345ab56ebf01c8750c953306c43ece2"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b34b9b83ef3b9a877bddb930fd61503345ab56ebf01c8750c953306c43ece2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e217997227a58705d3bdb2999a8b359d93e52c6acbac8a7ff6fcf1efe204a4a"
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