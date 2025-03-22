class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https:static-web-server.net"
  url "https:github.comstatic-web-serverstatic-web-serverarchiverefstagsv2.36.0.tar.gz"
  sha256 "bb99fd25835050e9572ea4589f66b94a64d1724712a2f4881ab35f29d1d8f2a9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comstatic-web-serverstatic-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3dafbf09781ed8276b396f8201d7a233a2d831d4034b6820c30648e5259da2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0b2ce83ef3ff7c5e2ce939480fb6614a1bf2ea0465b7b6317d9c1ca2be68fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62bd35f3a31cba5682609f6f4057c91720a37709f6304a23103a4287392c5439"
    sha256 cellar: :any_skip_relocation, sonoma:        "047279f00b897a5303869fad16babe6d7dfc9bd4a591b1135a58d57074078af5"
    sha256 cellar: :any_skip_relocation, ventura:       "4d7616c11305adb3afe499598bf318c0cbb96d8606be9aab1db4be581a45efa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f747ca12df0670a75f4c38c24635d8dbe14b4f4c042031917f883e8013b6a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ddd7cb7ac27d3ce88d242563fe310378fe6696f032644c394e6e88bd4f48153"
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