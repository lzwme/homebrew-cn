class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.5.0stgit-2.5.0.tar.gz"
  sha256 "68bfd3a33817057ae1b9587db5825eb42021f680615fcb88233f7cf001226f3b"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f04a601b3c87af86423942adba7d6083003312c3837a12748ac12515ee1b4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73328e862acd897a380bbbfb9c2bac9c1d605a48b3e3d1050e03e8c88abfcfa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e997c1d32150f855a1f7eec6df21d1cd310ea24a071063e075d160def382108"
    sha256 cellar: :any_skip_relocation, sonoma:        "950e7e8b2a5b12a39aa19c8afb43aec8f7be27d08b459f6b6d5c742cdf1a1768"
    sha256 cellar: :any_skip_relocation, ventura:       "7bcc68972166b6fb16683d736811061fcf6a37d4a8983320c96bd53e1b20c559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2dd38ab06f36b619b2ed87aeca157998c9773c93cf89e8d1a877c96b722de6"
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"
    system "make", "prefix=#{prefix}", "install-bin", "install-man"
    system "make", "prefix=#{prefix}", "-C", "contribvim", "install"
    generate_completions_from_executable(bin"stg", "completion")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system bin"stg", "--version"
    system bin"stg", "init"
    system bin"stg", "new", "-m", "patch0"
    (testpath"test").append_lines "a change"
    system bin"stg", "refresh"
    system bin"stg", "log"
    system "man", man"man1stg.1"
  end
end