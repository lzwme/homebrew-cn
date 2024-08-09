class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.11.31.tar.gz"
  sha256 "14274968d79ec95f8461c09ee4eaa5f047ffe9b6331d900aaa904a7a151763a8"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9fe49d5e06a4f2d601eb43a0f1abae114788fc74db3de2eae30c06b3cfb06b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a6e75da5f87d108d1755cf9bd9fdb7bacc7ace06fdd15962ff9bc4c5f149a0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48949322fc74afa4425e1b63129c45b96c664739f1e56be5838bda4a8c8b28cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e32185d809a5bbb6ad01bdafdb87be84ad762ac529bead20721403ccad9d7c1b"
    sha256 cellar: :any_skip_relocation, ventura:        "9bd8f3628377a1ba8ef5e1713a54a884d56b356557f968877e96de03c2341ef5"
    sha256 cellar: :any_skip_relocation, monterey:       "35b0ca670125be752ca8de590d8de416a9c61ac8172d21582e5f1b40520e5d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf0af687074b1d9144dc28afcc532416aeb70cc3b08a85966cea1c4e550a02f"
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