class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https:static-web-server.net"
  url "https:github.comstatic-web-serverstatic-web-serverarchiverefstagsv2.34.0.tar.gz"
  sha256 "f0b6ef64f68445c98f1ffd22265d5675e64157e572431fa4fd362970199d0b5e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comstatic-web-serverstatic-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91a1af6091454007fda0a0909aa9de0289cbd795ef20de52fd6997b6b83ae54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cc809c5be0224d3022c46a40f9d61bd1d88f76cf55ac4b4bfedfc888a25bb64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd90fa6188af4c1dbd3453e05d9f4c5038f73abe72a8e6d53b3620586f75d277"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab3b1eacf3459ab801548c1aed09992ea7e36ea1a3a6ec41a9808c46f75796f6"
    sha256 cellar: :any_skip_relocation, ventura:       "4be20e0ece975bb370fe6256511aa568968b53d37dd07b15c87d3390de3a6b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8b4240da5289d196616282a921648a2fd8b8d1ca2362f8983fc5bc0fc3311e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin"static-web-server", "generate", buildpath
    bash_completion.install "completionsstatic-web-server.bash" => "static-web-server"
    fish_completion.install "completionsstatic-web-server.fish"
    zsh_completion.install "completions_static-web-server"
    man1.install "manstatic-web-server-generate.1", "manstatic-web-server.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}static-web-server --version")

    (testpath"index.html").write <<~HTML
      <html>
      <head><title>Test<title><head>
      <body><h1>Hello, Homebrew!<h1><body>
      <html>
    HTML

    port = free_port
    pid = spawn bin"static-web-server", "--port", port.to_s, "--root", testpath.to_s
    sleep 2

    begin
      response = shell_output("curl -s http:127.0.0.1:#{port}")
      assert_match "Hello, Homebrew!", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end