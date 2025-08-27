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
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "123abac0cc1f1c77661a407c1ca5f2946bd327feaa4e83837a1287953d758f6c"
  end

  uses_from_macos "python"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"]
    # Build an `:all` bottle by removing test files
    rm_r "lib/spack/spack/test"

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