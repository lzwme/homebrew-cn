class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.33.1.tar.gz"
  sha256 "94e2ddf15d13a1a39ea20c79348dd08a78677eb309b832c8bc9efc96d10075be"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce734fe85e29eff81e524c72aa5c28ea18062762cd85b5f37336da0c1b8a6dbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcce175e2c4b5545eaa22b468ee920d4a4e0b4740d59ac4962869d5020d25bb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "090d6c13ad91095ba2d5f3e361156738a750451945ce4d444a9d9eaca3ae6cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca366cfe928a03bbec948b38b7e8fd4bcfbece61456718256769dd9a1bcf154c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404b29deef816151be0c8aa8665afb0b177342acc3e87c228ba59178123ad2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6cba9d14a9c493653739f5eaf4fd1c928f8a66dbcabc10abd96ebae5df65bfa"
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