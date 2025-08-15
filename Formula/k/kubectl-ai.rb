class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "c8a78503b5ef73aa3019fea86daa25f84c02e35c529070a87359351b10df5d04"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82658536af77961862842a8a2516d1017452dc760b60f55407633b6b6884c742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82658536af77961862842a8a2516d1017452dc760b60f55407633b6b6884c742"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82658536af77961862842a8a2516d1017452dc760b60f55407633b6b6884c742"
    sha256 cellar: :any_skip_relocation, sonoma:        "412f6d3ee92b48e80a1af0036a741d597c5030211921c17bccab480b353a7d68"
    sha256 cellar: :any_skip_relocation, ventura:       "412f6d3ee92b48e80a1af0036a741d597c5030211921c17bccab480b353a7d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56bc81b44e107c6de35ed400f6db8ad4a025423819734097588fb53fd21ffdd3"
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