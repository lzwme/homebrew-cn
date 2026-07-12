class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://ghfast.top/https://github.com/fatedier/frp/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "661554e336407880c444bf148b904f62f49c9442c4d71f3a2b0840dfbb12d678"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afe64cbc07076a14d87202f0b2d76a2c47992f5fa28bcb0d5bc77669233279db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe64cbc07076a14d87202f0b2d76a2c47992f5fa28bcb0d5bc77669233279db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afe64cbc07076a14d87202f0b2d76a2c47992f5fa28bcb0d5bc77669233279db"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eaa62cac39e4dd5ef43d93e76b15b0b9194c209a85996604f1bffd59c31c61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a040e6969d558ed18d2fa96db7aa75ec810ff6f44d1d61f819e4c2fb412deacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e629a48ff9e943bd52951558a5e4f22fce29b4c031ac3596ad7bc7cf231c9cb3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frpc" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"

    generate_completions_from_executable(bin/"frpc", "completion")
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end