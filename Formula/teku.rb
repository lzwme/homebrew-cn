class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.6.1",
      revision: "0b5ef8a4859f45cafd32d64018372515e16add88"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c765b5339c6a5eb4e686043560acee7e7b56d1a8a48585121641b8bf16f61b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c765b5339c6a5eb4e686043560acee7e7b56d1a8a48585121641b8bf16f61b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c765b5339c6a5eb4e686043560acee7e7b56d1a8a48585121641b8bf16f61b4"
    sha256 cellar: :any_skip_relocation, ventura:        "8f9280f98796bff12bf54ba5adfac4b3922f551cc664f691a47a447dc8f09b68"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9280f98796bff12bf54ba5adfac4b3922f551cc664f691a47a447dc8f09b68"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f9280f98796bff12bf54ba5adfac4b3922f551cc664f691a47a447dc8f09b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7460fb512632e4f8bed937da355eed34b9168c909762ca3872ae87f64a697f3"
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