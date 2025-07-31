class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "ef0f825c335870e6674b36da62665f7f31c9a4c77ebd8f00cef60875aa21e009"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19d4ef654d5ffe23221f3c916c432e12dcc0a5ff88b584041995439d7a821fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d4ef654d5ffe23221f3c916c432e12dcc0a5ff88b584041995439d7a821fca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19d4ef654d5ffe23221f3c916c432e12dcc0a5ff88b584041995439d7a821fca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7ac05ae4c61b752a9990be29e70db1fd1ae6cff632c2fd737f9cb744c681c8"
    sha256 cellar: :any_skip_relocation, ventura:       "ba7ac05ae4c61b752a9990be29e70db1fd1ae6cff632c2fd737f9cb744c681c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4a6d5f2f4aa89488589a37191fc26e9eeaee0dcc9c83c8ffba300c50f490b6"
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