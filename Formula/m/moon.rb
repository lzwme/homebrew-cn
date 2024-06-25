class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.26.1.tar.gz"
  sha256 "2ca19432f861a8dd1782d96ff4dae0608977e1115c08621b9afa732e714e81be"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b8782523f80b48d007bb231119e406f0c61c975fdfb32e9e414e9f413d4d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80a5ec333c67ea7c9f2f794e4591bdbf96d80d0aa583d95ddbe153fdc2cf91fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff674f21213a2eadeb7ab499d6e47d891ccf8a872cd5c680d28c51cea4c2900"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2607078eff3d35b90f4e723900018142a58205f4c0f1d1356b5cff63417bee1"
    sha256 cellar: :any_skip_relocation, ventura:        "175d65c9d8db63ffe09b56e6c8068b2fe30fc8826dea2d00be9a3c6ab8a7cd41"
    sha256 cellar: :any_skip_relocation, monterey:       "7ff3eb7e9ccc5302a1dafd81901b7255b7feaf9443d822c8b8a51c88e1582879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c4df14d2a001340247b2f2b7c36fdf442a3fc73f9a164f09c3820b270f73390"
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