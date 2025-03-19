class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.33.2.tar.gz"
  sha256 "b82f84b11d7c6a45455404e68d4bc85bb3dd622350d0fd67b807e7f4a9bef92c"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e0cc080fefcf53dc20ea45afd44adc037addf8d111aefafdc862197f8d243ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a00950f7ff11827ca46edb10db409bcf4e464ee240636bb6bffad80883f11b2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d30cbebbbd068d9178833384f9bac0886b511578cef17bca42f8bfcb0edf333"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41a60536d88830e5c7f35c20d3737bed43b8a1d6416a1d6397ae5d217ae088f"
    sha256 cellar: :any_skip_relocation, ventura:       "24be6fe0ad6da0b946703b5d7c52543ea14732d579ccb821d8269474bf2c0057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c765a74d288f507dfcd767b1c1aabf49236df0a5c735cffc2ac10d79dcb062"
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