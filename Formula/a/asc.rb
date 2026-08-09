class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.6.1.tar.gz"
  sha256 "ba7f8280b6718ceb0ff3c65a576bdfe28f9a63c46dfccd81aa727308b5d55909"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb10d51b49d0ab486c1a51ea05058b8fad75e3486f1bc3229fc85fd59e94e9a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "711f5174c0c7c0419dd25b576ac2155e0e9dacb3f40b39043073e333e061a1ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eeb3b8441fab6de42d6ab9db53a457797263dc83aa9157103ea309c8e168788"
    sha256 cellar: :any_skip_relocation, sonoma:        "d69cc5522a97b83324778cc9892b86332ca2ad5f6a0d422f5af09b930f97272d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97504f56656c5dfb84bcec51fba54c380f5bc67351b83694b9aafe2e843537d"
    sha256 cellar: :any,                 x86_64_linux:  "7913dbb7be7ccff04842a219b305b8486518b60bc324012c96bb89f66f0a75ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end