class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.30.2.tar.gz"
  sha256 "186212459fbdbbb67279df104c39c665851dc40db91e2d76a4c4212dbf4dbc79"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84b78fbd5edca93e3dc39a192bc4e77ed7f52b13376065ebe9fff955528ed0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a76074be465649a488a7a2918016b7003da38af84993b624eb35fc62682c554"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3da9e2221fc64287801cebf255d674df46aafd1ed4d49d670d27499127a36116"
    sha256 cellar: :any_skip_relocation, sonoma:        "165dac0da095bd6d59b43320c20e929a01ccecaa2d603d04d8c4d24f9c8a3fbd"
    sha256 cellar: :any_skip_relocation, ventura:       "22ee5aa2d4e79a04fd83fac9d8b4b18531891456bb9393188bd961352deace4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cbf92ee9febf692af0d1c632ace2e50b86be4217e7fcda6916c6b1f09d5d2e8"
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