class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.2.3.tar.gz"
  sha256 "707cd25ce7902a342dda6a0dce6d8bcdf3e1eefcacb7179f5e58e0d482fb5aaa"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "612b9a7aeab66791850275510f59173d0b78dc31109136c9793e1460883530e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0c86fb981910a493d7e809e722879cdb152eeeb2f5b365d6dfc5c396f013ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37631ffc4c224cb7efaccd54aaaf0c6e22b611e2d4ef04a0306a0c903d5455ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bb5fe28dea9ce857da42807ba5156fb101bfce327e029a34c4473e3d529376a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4696da981b457c7c66e5ac64f19af035efdd2ebc5d6d5cda14ba2ea5832103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83cf01656b8cdd99383849aa8db728e617c9df13cb8e3f95b33594ff873295e9"
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