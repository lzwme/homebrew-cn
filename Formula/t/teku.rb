class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.11.0",
      revision: "ee1e1aace63b9c8676ec2f01d93d4e6a3b955cea"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7efa2260edbe4d6b6f66e5ce29c32d53f752fcb0586e6e47a03489012dc268ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7efa2260edbe4d6b6f66e5ce29c32d53f752fcb0586e6e47a03489012dc268ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7efa2260edbe4d6b6f66e5ce29c32d53f752fcb0586e6e47a03489012dc268ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6f7e6b279563741793e818d0db563b23ae301191efcf5525f6d5c0c723ba415"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f7e6b279563741793e818d0db563b23ae301191efcf5525f6d5c0c723ba415"
    sha256 cellar: :any_skip_relocation, monterey:       "e6f7e6b279563741793e818d0db563b23ae301191efcf5525f6d5c0c723ba415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "884c487b85488d33c4c3d16634f7186d5f10082fa417eafa2a56219d3936af02"
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