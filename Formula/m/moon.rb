class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.35.6.tar.gz"
  sha256 "ad358f73812f35080cd5e9b4c3bac07972a67309cb7dde2fe7ea1a2e07392dd4"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb2d6cc1b5c40063cb3525eb9240c04f0b5f43644168e6a65801b8084dab229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4896c4c5872f04331a2935eb781b89f3e46025e336a1617ddcfc6ac923c321d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e0c1eaf5860be27e5e346a89eaf88a511e1350887fd8436ea6eaea3b93d9c68"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c1342246c3720f668dc6b2b067e36191f410b97f3842f47e6b00c63dbba07a"
    sha256 cellar: :any_skip_relocation, ventura:       "caa1085aa3c1516eedabf9cfc25319e7b53cb3a4cfb4125382518c7870db3571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eac85f47140029a974da8488678ea6cf3dcffa99e4991f83edb139c1219e526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de658fd56f578a812903db31aa084385bad43c16e50f2d710d723a483b1b278"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
    assert_path_exists testpath".moonworkspace.yml"
  end
end