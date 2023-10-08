class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://ghproxy.com/https://github.com/stacked-git/stgit/releases/download/v2.3.3/stgit-2.3.3.tar.gz"
  sha256 "49c6e93939e4c8256529eb828ce86470435a11aa73f73f8d0b36b584bace4c7b"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08f0139088a10c7c0b35e093f4c2302330149777558246a78ee9d3bab8caadca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aedf92f8f1068c4f2def6e98d76dd14639273be53b8837d28e4ced0668ea043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b127cc5e7de61a7daac9e8be4c852b17728602375533eabdab79b0217472c13"
    sha256 cellar: :any_skip_relocation, sonoma:         "2590e547b615c7ac57f201dd3571d75937954d77603aa4183e62e5cee924eb16"
    sha256 cellar: :any_skip_relocation, ventura:        "e0c9deffe3a87d6c47818112b58764d048cea9aa2ca6eaabb4f353fb07516f5d"
    sha256 cellar: :any_skip_relocation, monterey:       "b956c43885b0e675e8a04a8962f725e55a942eb1e999449efc2c034a46c97a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3dd8448b516e6f31aa4c9f223f4f0bcd1b56374663639652c1e1e5944d02d8"
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "prefix=#{prefix}", "install-bin", "install-man"
    system "make", "prefix=#{prefix}", "-C", "contrib/vim", "install"
    generate_completions_from_executable(bin/"stg", "completion")
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
    system "man", "#{man}/man1/stg.1"
  end
end