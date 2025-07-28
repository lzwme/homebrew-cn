class Brush < Formula
  desc "Bourne RUsty SHell (command interpreter)"
  homepage "https://github.com/reubeno/brush"
  url "https://ghfast.top/https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.2.20.tar.gz"
  sha256 "137e2df4dc752d4c2c393fa178005eaad6b691f6401e70897cbc6c4ac9fe8077"
  license "MIT"
  head "https://github.com/reubeno/brush.git", branch: "main"

  livecheck do
    url :stable
    regex(/brush-shell[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8794d2936afc5d7ebbbf75ee50bfc4ccaa5f2c94117c460c1772932152a177d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "257a0e4dfdd157153d99a9e625500e53bb16e7b72ab7d492a59bc43f53ffd606"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29b632465c3bbb57aa03c857a67fc6495a8293cb98daf15c9ca496a99a7cadd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca7987052c3be314b5dd960e5315179d57381dd58431ca88c15da3568d699de0"
    sha256 cellar: :any_skip_relocation, ventura:       "89337cf3e9fe70ebf7ade3838cdc49687a7b46c6863d817cd6b926d57f7dd6fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247f6a20f2802df922475d8ee124dffa1c62cba886a8222d4392401773294d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b639e0d9477f75a8af7819fe8fb4c03943b7104f91a9340f1f7e7066ba38b486"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "brush-shell")
  end

  test do
    assert_match "brush", shell_output("#{bin}/brush --version")
    assert_equal "homebrew", shell_output("#{bin}/brush -c 'echo homebrew'").chomp
  end
end