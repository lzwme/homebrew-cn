class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://ghfast.top/https://github.com/theopfr/somo/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8026a39058a0e71cc603cd887b4fd5c0eb8ff310fb5ee1a36ff98ebe90be5878"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74f4079925338ef4ffb144eabac0f44d70f6438ed624e5b26b48d0184cbb20f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361ee1f7ea7471cedd15bc41e560bde315a7d3900f671ff87c4515072d240426"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10f3e4c9fde2db017da386b5531e59b9f822b1cfed1ea5fba5e018e45caddba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0bcc7ffd62ef40c29c54be0c4b2d561b53a622bf97210465729fc3db0b8ca12"
    sha256 cellar: :any_skip_relocation, ventura:       "3fdd3ede9694025e2f26482f85c690b749db5602c6f2559b7fb8db3eb76c59ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0869f3c0b349ba88d6a0094ee4ab758eb59d7c3747b7820dbbb1f8f1c146c694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a353a71e91ebc13d27f31f624097d4a3b5b38481fe8e8be730cf3ebdfbd1176"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    TCPServer.open("localhost", port) do |_server|
      output = JSON.parse(shell_output("#{bin}/somo --json --port #{port}"))
      assert_equal port.to_s, output.first["local_port"]
    end
  end
end