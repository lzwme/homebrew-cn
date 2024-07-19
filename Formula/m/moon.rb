class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.2.tar.gz"
  sha256 "badd487079ce59de895041c015fa7ebd8990147cd3bf7268bd27dc5b7bf0200d"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "273d2c7f4bd7b193dd7cf2f508a7e9eb8246eaee892e721c0c9a47c5d0a040c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11e49851cb18961eeecc4ff0edca3cc657bb6a84ca1a4d3ff969126c1b493eb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1883fdab3e6611254f7558be511a25c96b2fa115008568129a5a34a1dae47f3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8caeed2046b168942938f567dfddc04c9315e4bdf7bf074e2e617846a1cbc019"
    sha256 cellar: :any_skip_relocation, ventura:        "640578920f7a03dc930950d6114320fdf607f6993462697de957bd3a8649c072"
    sha256 cellar: :any_skip_relocation, monterey:       "3738f2b464d09e475e4620bb7da4585f7e246f2c59048f4fb22f0e46cf4595a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47594f52ceb94760b6097ae3791aeba210dc2ededbef5a790586300089d09977"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end