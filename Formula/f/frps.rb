class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://ghfast.top/https://github.com/fatedier/frp/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "661554e336407880c444bf148b904f62f49c9442c4d71f3a2b0840dfbb12d678"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7bf468f9fcd5f7e46df54147519d65f6abd4207761cc317c75f330e06cd07af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7bf468f9fcd5f7e46df54147519d65f6abd4207761cc317c75f330e06cd07af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7bf468f9fcd5f7e46df54147519d65f6abd4207761cc317c75f330e06cd07af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b655f3f747b8a8cb2c10ff3375a2e38e93aa4335bc6105a6a95936dd65fad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "974dcda612db5008a3298e4381523b2de9419425cee95cf72e4e5221a982fc49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c4c32e661a90a8b6e8beb6be867c0092de73ac5b0515f22519774545ba9ee3b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frps" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frps"), "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"

    generate_completions_from_executable(bin/"frps", "completion")
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end