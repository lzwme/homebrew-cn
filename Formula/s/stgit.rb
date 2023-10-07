class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://ghproxy.com/https://github.com/stacked-git/stgit/releases/download/v2.3.3/stgit-2.3.3.tar.gz"
  sha256 "49c6e93939e4c8256529eb828ce86470435a11aa73f73f8d0b36b584bace4c7b"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f389daa4cb7027c053c085c6b4052d2918e9fd4c9755c476ce7c8437a2999fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf117f4a4296d2928db1ee3d5eb1f58ba2090486ef9e24b4f9f8ae92f05dc3e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e1bb7bff83e5a16f297a5e34fac90ab805dfb93b8c099405afeac3cf6b345f"
    sha256 cellar: :any_skip_relocation, sonoma:         "86a072aa3d18719abc7a0303a35105f2ef603fbd87cffca8185501e7f453427f"
    sha256 cellar: :any_skip_relocation, ventura:        "6e291017aa389b563029e4f65a454d6caeec7a5c04e584c1240129b9630b01b9"
    sha256 cellar: :any_skip_relocation, monterey:       "a3b684e492ec835b617dd344b62eff39968d9843c97e040bae3c7b44498a136b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276492aaa5dd4b0cd3b970c0c1c0074c096d2d0ae49f0d721088278f830e6afc"
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