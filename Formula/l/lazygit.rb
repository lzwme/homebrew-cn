class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https:github.comjesseduffieldlazygit"
  url "https:github.comjesseduffieldlazygitarchiverefstagsv0.47.2.tar.gz"
  sha256 "f8c28ff7389f0480d223c685496336f1fc8a48aca4748a9d7718dabdd09cb869"
  license "MIT"
  head "https:github.comjesseduffieldlazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25a46255f893ba1503b1920e4fbe94d15b36b5cd8816a42a7f13295dae7b117"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25a46255f893ba1503b1920e4fbe94d15b36b5cd8816a42a7f13295dae7b117"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d25a46255f893ba1503b1920e4fbe94d15b36b5cd8816a42a7f13295dae7b117"
    sha256 cellar: :any_skip_relocation, sonoma:        "92dc8524699dd8b2158d055ea3032c64da6e3ad58041b620a3474159d6fd3030"
    sha256 cellar: :any_skip_relocation, ventura:       "92dc8524699dd8b2158d055ea3032c64da6e3ad58041b620a3474159d6fd3030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74fc0e7556b4961c59add72612f8b149f7974924d8cf3b8fbf31405b5fe3bf5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}lazygit -v")
  end
end