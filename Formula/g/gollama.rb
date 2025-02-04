class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.28.10.tar.gz"
  sha256 "b131bc1f627926f10950fab1848e8e05626e2722adc78f0fc4952b2a34745c91"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c599d82a643f1925c673e683a8375386a9d5035577156878693c2b06bb0d1caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68a46fc92048c50c8f701009a39d84a8658e6045d7ea6acfd2caf63d8ca85ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34fc6e335d528c84e24f963f50bad1a547583bdc75cbd8756ca249b46695039b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f43fe6316ed5eb512da6c069d573a137e24b0441846da16df7049d40822bc306"
    sha256 cellar: :any_skip_relocation, ventura:       "41c966577efccff4941e558c54728edeefefca4e8574c81faaef222b13acc050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29fb202b897b49d5cd0d3aefd3f3ce93432173c5f8847d25e64079a5ecb3f1a"
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