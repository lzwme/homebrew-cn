class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https:github.comfacebookincubatorfastmod"
  url "https:github.comfacebookincubatorfastmodarchiverefstagsv0.4.4.tar.gz"
  sha256 "b438cc7564ef34d01f27cdd3cd50ee66a9915b9c50939ca021c6bee2e9c1f069"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "600929a7d4248733a13e358368319051565db1c568bca8c5a3c9ef11491fb9da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f264621edce82701f918ed54e31acc155523376ecd0b94735f189fd2e6cb82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3cf5f3e7db9c28665535bcd49de6370360a35a0df5d00666a8ccbaec1b6af5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f880861191ce5e9d4ae1f72c71842c49f268075e6c5d17e102c40fe076e13979"
    sha256 cellar: :any_skip_relocation, ventura:        "c2cd11d0b8f5bc395749013078c1667bf50b9f57d51768ec5bf47e6dbd85c79a"
    sha256 cellar: :any_skip_relocation, monterey:       "13ed79ccecfb9373661a3ae969f438bb9bf1753cc6142a99d050ec0fc6383f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9911efefe8693ee31af9c8b251ab3f524b67765b4f4920451c426b90bf05dc5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"input.txt").write("Hello, World!")
    system bin"fastmod", "-d", testpath, "--accept-all", "World", "fastmod"
    assert_equal "Hello, fastmod!", (testpath"input.txt").read
  end
end