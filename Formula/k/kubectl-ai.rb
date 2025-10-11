class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "fc1a31aca351f3f29859580f8167701e613ced5047ee2072b2d0e04b65be6027"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6badf346972ae542805cbeb73139407d0533c3c0e37ced7b0a6129477f10a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6badf346972ae542805cbeb73139407d0533c3c0e37ced7b0a6129477f10a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6badf346972ae542805cbeb73139407d0533c3c0e37ced7b0a6129477f10a8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "896bac0091a05fb5c499d176d7489dee9519785b040387589ab344435525a331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50d2aa642fb2deafdeca2bd73fa04f269698010f68da0ef3055d934ac64a090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d27f2e2c00f5bb15a4f34b4f27a842e4015b23b65c028703882d86fc1225bc"
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