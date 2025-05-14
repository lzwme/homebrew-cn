class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.35.7.tar.gz"
  sha256 "096ebf70acac0331b4083ba8d9e62388cd1c411936faed45df366e4766180638"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bb7afacaa8b6d4119c9fbf42a1a68726eef9b7cf2bd6eaaa412404e91cb3dd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4fdedf83412ba16edf07c7ddccce2bdd3b50d3565a31ff29451e52431c9f668"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a4b2f9e28d437c6d1e1cfcd9f44179079a50cb09110263115b9f6bba2fe1c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b49c416be826e34ecb2491a998bd27da23174d40202e297c486aec76186e1d"
    sha256 cellar: :any_skip_relocation, ventura:       "f9e46fdfd72a2abce480c8148ffb8ebfd8f18a7f1c44645fea5e06e2423da3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0767da4db4ab491194384460c021c33481dd2c2edff50b658c56849f22b7b316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b0069a7844114b970a61b65da4228ae150ff6dd7da2a8da89d68f88c1b978cd"
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