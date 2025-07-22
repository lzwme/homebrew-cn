class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://ghfast.top/https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "8f806542cd67f192610b2187cf6eb2fd0f0736309bf639af9fb6cb6a13d03d85"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d96c3d15c4e563f7b92dc138bce4a9351e00e0a57b50df64b14f3d70f2825253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75f466a6c5f77a81afe534357183bf76c587d3e0dbe72025ef08416576605df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42fb9a95a145e76d632f3ecf523f70c142bd68582a7cf3e1657f30f7609aa6de"
    sha256 cellar: :any_skip_relocation, sonoma:        "76751dd3ae908b6ca89b6757ff03cdbaeeb6c2f6da806719b052e48e8840017c"
    sha256 cellar: :any_skip_relocation, ventura:       "00d35ed285ac334753e2ad1d7b40bd5d3f666fe4ec220d961df6ff87fd0b7f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0deeeaa1519c5ec68524385a59cd25f70f0db96ba477a7a51e087631eaa5beab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c6b83b22adf99cce7d65d2a27e06e9edc546f4010a208caceb710ad9ebd146"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"static-web-server", "generate", buildpath
    bash_completion.install "completions/static-web-server.bash" => "static-web-server"
    fish_completion.install "completions/static-web-server.fish"
    zsh_completion.install "completions/_static-web-server"
    man1.install "man/static-web-server-generate.1", "man/static-web-server.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/static-web-server --version")

    (testpath/"index.html").write <<~HTML
      <html>
      <head><title>Test</title></head>
      <body><h1>Hello, Homebrew!</h1></body>
      </html>
    HTML

    port = free_port
    pid = spawn bin/"static-web-server", "--port", port.to_s, "--root", testpath.to_s
    sleep 2

    begin
      response = shell_output("curl -s http://127.0.0.1:#{port}")
      assert_match "Hello, Homebrew!", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end