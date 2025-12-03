class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "b9c6edc1db0238ec79049c4090fec57023a00e13f72e1125cdbefe7ed10eb948"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a55f94f1953ddaec0707e1572a6a9537251a3eda5ccaadc5712e85a950453d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a55f94f1953ddaec0707e1572a6a9537251a3eda5ccaadc5712e85a950453d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a55f94f1953ddaec0707e1572a6a9537251a3eda5ccaadc5712e85a950453d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1bc2c5fdd677d4ef9f4179d784724c61cfe5e7ec1181238c0f49d81532db54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb1c4844e7a10ef7fa38f195285900105f84cf388b4a0567ab4a6842130c77dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9282d1dfac83cf8b9bedb6ed2c6e549ee49af76e4d3cef97f36487cd55157d3a"
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