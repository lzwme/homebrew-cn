class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.4.0",
      revision: "196c4c177ceac032f27d6ec1de249e6318538cef"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be89b1222c7ca7b48d44c14edfd7ca95088299eacce7bdc20dd3bc1e67231ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be89b1222c7ca7b48d44c14edfd7ca95088299eacce7bdc20dd3bc1e67231ebf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be89b1222c7ca7b48d44c14edfd7ca95088299eacce7bdc20dd3bc1e67231ebf"
    sha256 cellar: :any_skip_relocation, ventura:        "ec0d07f61281ece6fe8b45b35339308d5ef1c8df33890e55b4e7bebf153a7ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "ec0d07f61281ece6fe8b45b35339308d5ef1c8df33890e55b4e7bebf153a7ff6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec0d07f61281ece6fe8b45b35339308d5ef1c8df33890e55b4e7bebf153a7ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e390cf3c143099eb664fb0b8d65b1ae19e02912c7c60f64b96b04c61617da69f"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "installDist"

    libexec.install Dir["build/install/teku/*"]

    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    fork do
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false", "--ee-endpoint=http://127.0.0.1"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end