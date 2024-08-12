class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.3.tar.gz"
  sha256 "f3dd9bd5e7e5a1a97e1fb1fc321dfa9ed1e647c9da7721a7ba7eb5630d330bd2"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9508930134b13d09589e112487cd577dddb5abe861f63b12ff48c374dd7d14d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9508930134b13d09589e112487cd577dddb5abe861f63b12ff48c374dd7d14d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9508930134b13d09589e112487cd577dddb5abe861f63b12ff48c374dd7d14d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "099eef212c3e3af83d57eba58ce35d127db8ba1577b183820b4e731f5cb72fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "099eef212c3e3af83d57eba58ce35d127db8ba1577b183820b4e731f5cb72fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "099eef212c3e3af83d57eba58ce35d127db8ba1577b183820b4e731f5cb72fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9508930134b13d09589e112487cd577dddb5abe861f63b12ff48c374dd7d14d0"
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