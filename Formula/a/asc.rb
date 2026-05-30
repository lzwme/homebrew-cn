class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.6.1.tar.gz"
  sha256 "74b5587a08d93007975662330eac7ad486187240e0fb9cc0e9f200cca339ddeb"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df993f101e165365350ba7f32001d5ff4ba920fcbb52f0f8f432a7f3e5b0f182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5da06bcf1a680574b2559e4336e165545c1849f6ab9d940a7feed6b09377b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8011632e02877f7c69b5dd1699154512e209cc8f93ef5032fc22250be0e3d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0c2d25a0432383b53e0b64359697bdb9e1e01e02a18831632585a8a49c44d35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37876186aa5e42407c72bdb04238b2143adce0690f56adbd5b0693c2faed871e"
    sha256 cellar: :any,                 x86_64_linux:  "26b743d9236b2694b27a136c102444ed7144f37564cbc0e6008d6e39c7251d7e"
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