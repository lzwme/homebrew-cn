class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "8f6b157bfa7033f1d5fc581861b94fc4f1173a3bacadeed1688cdc750e66b6d0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847f4a3055889083ea0075e6bcb3c7e19d778e5d079f44057eb2d71acb007319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "847f4a3055889083ea0075e6bcb3c7e19d778e5d079f44057eb2d71acb007319"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "847f4a3055889083ea0075e6bcb3c7e19d778e5d079f44057eb2d71acb007319"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c82cde8e6e49a77fb74ebf0dbfcf7d3bc1edcc33d4189097395060bcb59cc3"
    sha256 cellar: :any_skip_relocation, ventura:       "98c82cde8e6e49a77fb74ebf0dbfcf7d3bc1edcc33d4189097395060bcb59cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b88b42d1f24cce7c9c646721368f92c819391ce42682979024db175a22c21c4"
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