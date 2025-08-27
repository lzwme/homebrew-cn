class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "265de8135d26d5262a6de46839ec9ff262cd3fa2c1141b9529ca2ae744001aed"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d988cb1459e328c06114208cc3d0cc7d8651b0a626313e827dc93f9cd9e988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d988cb1459e328c06114208cc3d0cc7d8651b0a626313e827dc93f9cd9e988"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3d988cb1459e328c06114208cc3d0cc7d8651b0a626313e827dc93f9cd9e988"
    sha256 cellar: :any_skip_relocation, sonoma:        "c12be629be6e15ce6f3ee09de444ee92013328e85f57b9a72dbd11f2b721b702"
    sha256 cellar: :any_skip_relocation, ventura:       "c12be629be6e15ce6f3ee09de444ee92013328e85f57b9a72dbd11f2b721b702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3864b8fd63ca4501fc8282ff144f72f0f0a2c6b747bc21a580d2e777e7b08f7"
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