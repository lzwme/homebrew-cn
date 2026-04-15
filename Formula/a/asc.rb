class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/1.2.2.tar.gz"
  sha256 "3534ea61a771ab63547fcb3b3c6deca4b047c9fd381d6df10fc1edf8cae30a7d"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a92e80ef1712c44f9be31810f09550d05a913139d08671e64c55b7a2026c664d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d86f25928d29aa36c6048efb9db13545925f98b972e73ab48e763f2a3b55734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a98857ab4f762164c60f6ccc94c8ef66851834284831715be0cccb012ec1653"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd1b07e881a9cf54ed7abe6de223aa8d66c05cd8175f46c9ac60811c42cafc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89c95ff799b4ecaac51d555ee351c541bbaf46f09f2bb17b739aebd73d9444d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51f45345d06becb20e72ad630f89490e302a9a0b283a5a4cddaba69a3be2b06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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