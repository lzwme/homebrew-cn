class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.5.tar.gz"
  sha256 "4cc2ea7505c3d715898d54e466aaf1bb76976826c0223d4ad270e01b5b137b40"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1712780702cc27fcf0becd3cfd3c8bcd10afb62f595a878602c330df7bfcff0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57fa9cf68b2d46b12ca3ca4dd4e13cd00edad759c79d22032ec91a0c5fac7008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dd17fa824edc2d4cde48a6bc5e7aa47d886750560f3b0cc1cdc6bec09a3f437"
    sha256 cellar: :any_skip_relocation, ventura:        "9ecfd02b4b0b90cec68411af00528d0e0cd0e09b98858d114fad15a0bd470bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "e2542a3cb68259497bab41297f37a33b76a455107c253ca251bdd9c21bd35e9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6788b393522c3aff33084b1f2f23c579fbf46938274e043a81e91e68ea19a82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86a06a8f5b1ac3369b05ce4f0c1ffcbdc7fe1b91c72144d9bc7869a0e897425e"
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