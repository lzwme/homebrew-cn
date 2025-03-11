class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.9.tar.gz"
  sha256 "de12429492c5947ecbded7896bcf64db1b7df7190e92f74c04af16cd09937531"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea67a4dd8f4a9b47ea617eef8628d3fd41a5e451c0d978e2933291f2066db910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9009032932cafa77ef5d2cc5cfb89924fa89acdbaef277014ac1bb2eb087bcca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d96bf1f06a09ac378ca31386e35d70cfd40c8c5881d2f593d59e9e590adb1a0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea31a0b397d1516c16d4040bc5abd3c74f4a4532ef4347af088a613086d47aaa"
    sha256 cellar: :any_skip_relocation, ventura:       "3ecca278b130971eb8e8b0e3bd58f6b3e484f467a775eed3c0073394a978a06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bdd75fe2171624c2bed6c2ace427796d548bff8a8864e824addc75cd8eafc7f"
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