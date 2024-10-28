class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.15.tar.gz"
  sha256 "df7eb09ff4d36c054b74849fd37c076750db5a23d4c29f32d7dc7e03e1101131"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dcc9019249070374fad1c290669ff8abe18e5ad4e7bff904735a0a0b7235dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54825a68ba98dc202e2b4cae1486fae5e714215ff1fc2b6748866ae5385b6a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5e40eb191df3ff2ca30a7da6f177b32dd4c4ab757904fc61852fc7f453b7a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e00f0a296d5c650e4a3e8dfc7632f0659c3d5be977bff049580b580c8226817"
    sha256 cellar: :any_skip_relocation, ventura:       "f52c16a9536285f979433dfb4847fcd8b2bd972fabefaef07e7945dcb61114b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d194c7c5e7d9efd1ecb3505eea427beecfec4309f5414d612458e5e47e4912b1"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin"gollama -h http:localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end