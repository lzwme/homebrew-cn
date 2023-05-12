class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.7.tar.gz"
  sha256 "1f74dc9936150afb19de3492cda0f1049240fb653782d82c4e7bc4018548be2a"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f226f46cb870ae2167919ac84ff01c6e8a6271a9661a5b5bf6d0809918422ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca49a52711727c244920caaaa303a5b6d4714596550515bbae4233735e0b84e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c23db2b988f99d9029a97a1ff9ee3a81e6ea6920d704fce1c9a4fc68fdbcc01b"
    sha256 cellar: :any_skip_relocation, ventura:        "d39b52a96ec9e8488666c15c457ba19bc0f10ef2e8df14283100ec7f7525b253"
    sha256 cellar: :any_skip_relocation, monterey:       "1263912643c9f58f3c344f0b7e1cc15f0ccb6a3970838886bfdb144a8a46808f"
    sha256 cellar: :any_skip_relocation, big_sur:        "97158d7758d376556eadc5b5c2d500820a164e4898cc8361d32399d1f9970ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "423663b061d5ada66e96b0b59b37ce619e76d982be8f4be83a265e972a814789"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end