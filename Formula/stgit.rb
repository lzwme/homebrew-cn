class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://ghproxy.com/https://github.com/stacked-git/stgit/releases/download/v2.2.4/stgit-2.2.4.tar.gz"
  sha256 "858929098bbe156bc73b2518a870e51bc63f6ebef1ac7dc61f6cebc2d2553a43"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59dbd96949129cbaf487e1b20b3e73c68b8d9666788209f36d9273c2452dcdfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7b9f647bfa0fa23bfc57e5a2e9906d94c9b2e38b997ecd247d7b7a4429e7cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43f6a12e549fe755de7fa7a9285180fc6a03210a70662a3d1ca93089ece8a41b"
    sha256 cellar: :any_skip_relocation, ventura:        "6ee66939f31d71a4128178efed4a2caf3afc13e3f55b305e655cd90374c8b545"
    sha256 cellar: :any_skip_relocation, monterey:       "674a65d1a5dc2aef96a40a056332c3447c0e5c6b2043ba35dd4c8653bf3d0fb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1718120ae6f21839c412cdb456018399ca77769bbdb37ae8bb69317f55e0636e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2fa95ec36871ffaeb2200096a1557e915781b20a85feb7fd4dd434129ef0201"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"stg", "completion")

    system "make", "-C", "contrib", "prefix=#{prefix}", "all"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end