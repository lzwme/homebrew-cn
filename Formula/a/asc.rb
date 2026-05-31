class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.7.0.tar.gz"
  sha256 "fd5311d559f5273d6cd11ac9664811ed31784bc34339ce777cf342f9e1a485a8"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "925e8b091dcfe7cdc69a54640853ad8181283801c95f6afd01066bcf42c510fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c76971004b6516d0511f77e091dd8a5c19b46dc13930937c77b472a4abdda82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b0cf81dbee7b3e608c14de08c72ab821cdd852b500b9859f4dd28f519b5891b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6752d08c2e2295c5d26b4ac1eddab1de9751dd88d2367a5b4ae2f11292820237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94305cd762fc2221d01a083d3598c005d289a357d02944f5f4b188cfcbf93247"
    sha256 cellar: :any,                 x86_64_linux:  "34cadb03b03257fff2c6ae8608e731e2f373c70e477eb8f74996bb6e75a0662e"
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