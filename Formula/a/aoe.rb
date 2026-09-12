class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "160bc8e40e1a7d9d71fad2b555dea8b834a5bdcd94959b112d0f5a9efcfc3d8c"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea73a5c53067cd80a20f46f4687e210ca6580f857e01fdd73d38f1f0794bfc23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a2c7b6939dd0928c272e9461c04375a83801ddb5c9bc3cda96dd9125c88ccb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fea810bfebb694d18c0d51c07bf43eb56ec7fa9d26be39886deac5610f7d5eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6048b7500588631d86163fb4bddd0dd766cc1aa1f20ea34dc9b97afdd63e33cd"
    sha256 cellar: :any,                 arm64_linux:       "d42d43921349d01a87a522fbe91a50e9fbd6024f1a3717bf26972965a356674b"
    sha256 cellar: :any,                 x86_64_linux:      "d643e0f187705be70f20e8be62a91f66243b628992c8ad0d1f8c5e82ade73c98"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end