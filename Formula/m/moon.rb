class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.36.2.tar.gz"
  sha256 "b526c712021c7566787ac4aa145913e5c70ad6962fb4abc142183643a69c1f81"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d11e5fb71378f64d4597acf8233cb2d4f4ee7a2a6498a6b87a8c2b675094546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8f6a1ca6bcd0796da63faa37ba8e359bb450f91b42952eba4a173d748dd66be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "513f321abc03ceebbd4aa793990964a0c5295fbdd3cf7a36502b6301806bab82"
    sha256 cellar: :any_skip_relocation, sonoma:        "13067f143ae079029d996c524bf16361142ab6b17ed69ed8013c82e2cbbf0c58"
    sha256 cellar: :any_skip_relocation, ventura:       "1afc9b612f60bc40fa3c8ec4d206f0d29b468bea301758262cc66f4717b8f5df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00589cadb4f5b19ac93ca0e6cd449cb98a6102b9231bc53ebbeab61b1ff451a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1034f90b92b9b355f925be615d6a2be6d1ee9fdd350efba99fac5604c395e38"
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