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
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "7ac4187c520f5429bdd8e5c407188fbfbd778795bb4437a8e762934619bc5d9d"
  end

  uses_from_macos "python"

  skip_clean "var/spack/junit-report"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"]
    # Build an `:all` bottle by removing test files
    rm_r "lib/spack/spack/test"

    prefix.install Dir["*"]
    (prefix/"var/spack/junit-report").mkpath
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