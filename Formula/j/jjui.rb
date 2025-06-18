class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https:github.comidursunjjui"
  url "https:github.comidursunjjuiarchiverefstagsv0.8.11.tar.gz"
  sha256 "b3ae1fe3c433743ffae00b27e10817f2b46a773dc5b73b366cac350867a1c218"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d3818ae4e3194d2668a942727922d8e185f10f8d8a61121af3e3c0b9e85c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d3818ae4e3194d2668a942727922d8e185f10f8d8a61121af3e3c0b9e85c3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15d3818ae4e3194d2668a942727922d8e185f10f8d8a61121af3e3c0b9e85c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed49e70def12ee3105a89f81a446c606d9ed333d4a3d04caf82425e35029cc5"
    sha256 cellar: :any_skip_relocation, ventura:       "4ed49e70def12ee3105a89f81a446c606d9ed333d4a3d04caf82425e35029cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52489ca4f1473988ead5d2b5be2f5e157216ffe2012975153ef76925cceb27c2"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmdjjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}jjui 2>&1", 1)
  end
end