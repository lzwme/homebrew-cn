class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "892aa6f196c9fd4a2f1231294eb21513a6f30cd30949b981d0f208ce14fc3ac7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b54cdc8a4b633270d3e19f16a0effbf21ce5497de2be27702435e638bcd2b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b54cdc8a4b633270d3e19f16a0effbf21ce5497de2be27702435e638bcd2b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6b54cdc8a4b633270d3e19f16a0effbf21ce5497de2be27702435e638bcd2b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc78d6857844e7e1519fd1d2084febdd05cc707f0cebc0de28d3a9476a7e0d4f"
    sha256 cellar: :any_skip_relocation, ventura:       "bc78d6857844e7e1519fd1d2084febdd05cc707f0cebc0de28d3a9476a7e0d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b632ba465c55f37645b67c194eb02f404c94ff7dad7f8e530f3e2af36fdee4b"
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