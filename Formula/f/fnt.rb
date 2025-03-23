class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOSlinux"
  homepage "https:github.comalexmyczkofnt"
  url "https:github.comalexmyczkofntarchiverefstags1.9.tar.gz"
  sha256 "4801b58e007aa5d84b112afbea3a5e449fb8d73124fb34182efe228fc37ac3e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7643970e5f382eee3b375961250697f97f3699b4d6372629ec8aeda86826ddde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7643970e5f382eee3b375961250697f97f3699b4d6372629ec8aeda86826ddde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7643970e5f382eee3b375961250697f97f3699b4d6372629ec8aeda86826ddde"
    sha256 cellar: :any_skip_relocation, sonoma:        "8285538de10d36c7c20adf1275759cfbba3d3dc44c7852e9d69938a3c9b74562"
    sha256 cellar: :any_skip_relocation, ventura:       "8285538de10d36c7c20adf1275759cfbba3d3dc44c7852e9d69938a3c9b74562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7643970e5f382eee3b375961250697f97f3699b4d6372629ec8aeda86826ddde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7643970e5f382eee3b375961250697f97f3699b4d6372629ec8aeda86826ddde"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  on_macos do
    depends_on "md5sha1sum"
  end

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}fnt info")
  end
end