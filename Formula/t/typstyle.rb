class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.8.tar.gz"
  sha256 "a0ec405addfd4b0837838a963d3e57c1063c34a3cf12bfe71aa2e1394190e663"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335a52edf9b05939f4fdc59a46c7a78e4371aca6404b593fe4932dcb108c7fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed10c0d412567bd1a471eff2de398afb08c44cbdb1a8f432d3209fe968c7aefe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "065a67d455be573f919c7664550e6a55b03a85763a85848566a745c5346bf01f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c454f1b2d962eed8f151bbda2edc79b32161412629531e4c1446338314fcb299"
    sha256 cellar: :any_skip_relocation, ventura:       "dd1e1370efc8ed7ee9f2631288c7d62787ca28f037220d86eb98505c20c3ffc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3c01897caf48c15b3d4904fc508499507b92fd9e25974c44fe94f13c807c20"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end