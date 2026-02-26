class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.34.0.tar.gz"
  sha256 "dcb2e0af903a1dfa1ca93513a47f5bf81cb5ba217ccdc48ec141b8d768351842"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "732f1fc919718f3fef6c652b0068a49d4b436bdb0fb507da58dd2d222e2832ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19dee228c40a695a04d53d165978685e1f8e0e83c7c443bb9c5da0c156522e10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d8d7208b5cedc173a178c6645b257baa8d24dd9869a4187b00edc3ab79debdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "588ab08ffba9fddb9c15831d4ba495bbff7f7c4750211a586b30a9017a99d5b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0e0ce32804fb3348c84f641195e59a0f134701601c55794be61e91b8229de3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523bb4d5ad063f32cb4be3dc3287d0a499fda99e2fda09bf3e968a8cb8f7a8c4"
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