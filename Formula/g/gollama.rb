class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.32.2.tar.gz"
  sha256 "14c8415bf54a79b34ecaa81cdd54e0fa273b5228f4bc86c763c47061e8f8c3f0"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ab57ab3fe2146a4f051ba2165f82f5cf551787460eadd2c45b1a8027a21267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37bfe65daaeb36cc5ec82c506310acebad5ecb39bef4b2fced193e9dc54ebcf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd64d21b30f482abac1378d2140847547875ac48fe0b8e451aebe6f3890147bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c6d7020ddaa4a8711367cd6abeedf56146462d37a4f8c700ed31240bfcdcc3e"
    sha256 cellar: :any_skip_relocation, ventura:       "e3ee90fcf277da22b3bccd85e5eba9c1d2956643cd56197bdb048e40ed14def0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beb9f48489117a6e54ce2c75377520e4c533fc79456b6d0da006080f6a71f01b"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X main.Version=#{version}"
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