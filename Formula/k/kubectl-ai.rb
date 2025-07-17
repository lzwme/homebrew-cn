class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "89ebb0fcb97d5c9dbd6a85bad39ac00543837d61a4689374fd167dc96ca9b9c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e0586fad4bab506feec1bf464747e7de003abc3d7ca06f7710bdbfa4783c05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83e0586fad4bab506feec1bf464747e7de003abc3d7ca06f7710bdbfa4783c05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e0586fad4bab506feec1bf464747e7de003abc3d7ca06f7710bdbfa4783c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "05640b8270fdceaf59128d6a8d7c3b6cfadeb1715eecbaa0fd5918437de5c515"
    sha256 cellar: :any_skip_relocation, ventura:       "05640b8270fdceaf59128d6a8d7c3b6cfadeb1715eecbaa0fd5918437de5c515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12bb90ec606857fe067efeaf37c39d88c74db1f127520a905f2d1159a3510d9c"
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