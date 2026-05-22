class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://ghfast.top/https://github.com/fatedier/frp/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "b78879e74e44bb22805a8a4602c6f58b9f46971c003eb4079d5020f66e57ed37"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f48b9c41598f1469c027984db7dda2f71fbe5d3224539793669301ad2e8485b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f48b9c41598f1469c027984db7dda2f71fbe5d3224539793669301ad2e8485b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f48b9c41598f1469c027984db7dda2f71fbe5d3224539793669301ad2e8485b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b402bb361b39763a772bb58b4ec38a5294cf873c5927278ed2381348f986734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f43896b1c2a13289cb29e474ce71839e81bbf684b47d805ad7663fc4ac60d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "949710bf69f11268fac78964705bd13a692ed40635d14c97772da9db9e8c7699"
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