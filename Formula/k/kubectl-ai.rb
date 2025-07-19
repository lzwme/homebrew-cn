class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "b7413e0c8e334446a39f813ca540ae8d23c6bd21a2dbd385ac702e61b84b4a4a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a66185940b1445f49b3fb7fcabb37d1cad0fdff661e23cdbd04d03ff8100438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a66185940b1445f49b3fb7fcabb37d1cad0fdff661e23cdbd04d03ff8100438"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a66185940b1445f49b3fb7fcabb37d1cad0fdff661e23cdbd04d03ff8100438"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec840cd323b9cfeadfdcbb2825b82ccbec19c8ee9239a0649cf1fd427f8494ac"
    sha256 cellar: :any_skip_relocation, ventura:       "ec840cd323b9cfeadfdcbb2825b82ccbec19c8ee9239a0649cf1fd427f8494ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8afdce59d96bc1f08894bb8748fabc7c4254bb84372d6ee561730de2ea68a22e"
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