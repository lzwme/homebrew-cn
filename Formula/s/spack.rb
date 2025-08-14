class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://ghfast.top/https://github.com/spack/spack/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "dd1345427dbc9281f359bdb6d0d53cb38edb94fd2ebee3256fda441c8242205e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24740174b2c04b46afb1bf30566f7623833212e62bd63c732ad88835c4d457ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24740174b2c04b46afb1bf30566f7623833212e62bd63c732ad88835c4d457ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24740174b2c04b46afb1bf30566f7623833212e62bd63c732ad88835c4d457ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb62f39f80b60afe1b133749f2d1f69ccdea05096ca5c8670cef2b79f0199425"
    sha256 cellar: :any_skip_relocation, ventura:       "fb62f39f80b60afe1b133749f2d1f69ccdea05096ca5c8670cef2b79f0199425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24740174b2c04b46afb1bf30566f7623833212e62bd63c732ad88835c4d457ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24740174b2c04b46afb1bf30566f7623833212e62bd63c732ad88835c4d457ce"
  end

  uses_from_macos "python"

  def install
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"] # Remove Windows files.
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    ENV["SPACK_USER_CONFIG_PATH"] = testpath
    (testpath/"config.yaml").write <<~YAML
      config:
        install_tree: #{testpath}/opt/spack
    YAML

    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    system bin/"spack", "compiler", "find"
    expected = OS.mac? ? "clang" : "gcc"
    assert_match expected, shell_output("#{bin}/spack compiler list")
  end
end