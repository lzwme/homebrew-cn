class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.10.tar.gz"
  sha256 "94ede57870b7ff1c4f3fd1904ced39705f6b9e0859cf3f0dfc9abe25cd01eb54"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb2ffa0628cc8039cac5aed017dbe57a8c59477bca13cf7d30cc5d1db75a0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb2ffa0628cc8039cac5aed017dbe57a8c59477bca13cf7d30cc5d1db75a0f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdb2ffa0628cc8039cac5aed017dbe57a8c59477bca13cf7d30cc5d1db75a0f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b9ab1549bbcc98e4dd3581c3685096405a07e294063ecb293c1ed71ce24a8f6"
    sha256 cellar: :any_skip_relocation, ventura:       "1b9ab1549bbcc98e4dd3581c3685096405a07e294063ecb293c1ed71ce24a8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb2ffa0628cc8039cac5aed017dbe57a8c59477bca13cf7d30cc5d1db75a0f6"
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