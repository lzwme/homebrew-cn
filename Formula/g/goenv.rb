class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.17.tar.gz"
  sha256 "a171628223971fc7758a4f68e0c779c05ea19df3aa43dc0b5d70f23e6037e634"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "71113ddfe6e19afe102383f4c545e8e7107730e7633ba22d8d104c0c21cbb41b"
    sha256 cellar: :any_skip_relocation, ventura:       "71113ddfe6e19afe102383f4c545e8e7107730e7633ba22d8d104c0c21cbb41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
  end

  def install
    inreplace_files = [
      "libexecgoenv",
      "pluginsgo-buildinstall.sh",
      "testgoenv.bats",
      "testtest_helper.bash",
    ]
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}pluginsgo-buildbin#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}goenv help")
  end
end