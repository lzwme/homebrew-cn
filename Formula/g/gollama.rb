class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "dd999558960f63daf36be8fe9fc04c32a15f53216115420c554b81cec6becb69"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f27b92e79e8369ed3abf439ac8378ad540a662e923ce1a8510d1877dbcc3dcff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79c0f3fb3852165db50d806831c26d8037aaac4bac93afef93886aac0e57803d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dff018dc8a4fe2ac3539e8b6166bf7655274834ff47dbf7c8ae3572a1bf485e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "59893a878809e9a1265722d9a15301ab1ff6bfceaecc452bf922ca8fd4a7a3a0"
    sha256 cellar: :any,                 x86_64_linux:      "edaa137de88f7c606be15cdb1925961ebb243334cbde1b74290b03025fcacb39"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn formula_opt_bin("ollama")/"ollama", "serve"
    begin
      sleep 3
      output = shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
      assert_match "No matching models found.", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end