class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.31.0.tar.gz"
  sha256 "537e816f331638d2a9d41773a1ec044423175a8aebf9be45d041f11fcb6d4e11"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b000326e87a73f94f3d3da6bf01d64d3af4d968a042c94c24482a5a94f94863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5756ce4c650f773e37cf160d53dba6c1b704299a83f08d19d551ea1c3bcbed6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "168aec47f3502c3af5c026cb2c86fa50072f428481ad26bfb718e6549c10f732"
    sha256 cellar: :any_skip_relocation, sonoma:        "27d732a0a4b7ffd77b39906fa8e0ebf4438e0a7ffc68df4036cc6cdecdc3408d"
    sha256 cellar: :any_skip_relocation, ventura:       "a1497454f925d533983e9f40a03fb63957f907b8589cff11fc3564327db0710e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac1aeec0c01141bb3f2c5f1f169bf1c5930ae3e1c1e24e7a6061dffcbf398274"
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