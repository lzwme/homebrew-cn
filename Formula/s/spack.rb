class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https:spack.io"
  url "https:github.comspackspackarchiverefstagsv0.21.0.tar.gz"
  sha256 "98680e52591428dc194a021e673a79bdc7799f394c1217b3fc22c89465159a84"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comspackspack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04cdbc007c91a548dcfb7c5226c6d1a0e2264e32417079ec48ea9163dc94869e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04cdbc007c91a548dcfb7c5226c6d1a0e2264e32417079ec48ea9163dc94869e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04cdbc007c91a548dcfb7c5226c6d1a0e2264e32417079ec48ea9163dc94869e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ae68694782ef6e3a5e3eb7761a840029266bb6df4e7ee71e904887152c437f8"
    sha256 cellar: :any_skip_relocation, ventura:        "0ae68694782ef6e3a5e3eb7761a840029266bb6df4e7ee71e904887152c437f8"
    sha256 cellar: :any_skip_relocation, monterey:       "0ae68694782ef6e3a5e3eb7761a840029266bb6df4e7ee71e904887152c437f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9601a37ab12ab942e35ba55a7e6810b087bc9569329c01c0508a660a4b6252d"
  end

  uses_from_macos "python"

  def install
    rm Dir["bin*.bat", "bin*.ps1", "binhaspywin.py"] # Remove Windows files.
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix"varspackjunit-report" unless (prefix"varspackjunit-report").exist?
  end

  test do
    system bin"spack", "--version"
    assert_match "zlib", shell_output("#{bin}spack info zlib")
    system bin"spack", "compiler", "find"
    expected = OS.mac? ? "clang" : "gcc"
    assert_match expected, shell_output("#{bin}spack compiler list")
  end
end