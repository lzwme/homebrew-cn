class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "e84e7f7d569f2119d359e2cef923a05c7dc4265fb9d7dda8122fe552ff289978"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76771a63a1685fbb759e3cc38c3c6e05e815096134b28c0b3c84a921d83246d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76771a63a1685fbb759e3cc38c3c6e05e815096134b28c0b3c84a921d83246d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76771a63a1685fbb759e3cc38c3c6e05e815096134b28c0b3c84a921d83246d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "36aad2ca42e122d27eca0ea56c5d311fcbfbbdc799382dfdb0102c4aaab0d5dd"
    sha256 cellar: :any_skip_relocation, ventura:       "36aad2ca42e122d27eca0ea56c5d311fcbfbbdc799382dfdb0102c4aaab0d5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab009930b35b7fbf19cc134ca832bb09551365c1ae3b99cb9fb903e2f2f388da"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubectl-ai", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-ai version")

    ENV["GEMINI_API_KEY"] = "test"
    PTY.spawn(bin/"kubectl-ai", "--llm-provider", "gemini") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "Hey there, what can I help you with", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end