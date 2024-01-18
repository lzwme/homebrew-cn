class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https:spack.io"
  url "https:github.comspackspackarchiverefstagsv0.21.1.tar.gz"
  sha256 "9a66bc8b59d436d5c0bd7b052c36d2177b228665ece6c9a2c339c2acb3f9103e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comspackspack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7cd40d7e2b17ed5e63ba370cc144c715f6b80163bd05ae02002d31fc40be14a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7cd40d7e2b17ed5e63ba370cc144c715f6b80163bd05ae02002d31fc40be14a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7cd40d7e2b17ed5e63ba370cc144c715f6b80163bd05ae02002d31fc40be14a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6c2fe154acac06b388bdce117fd0d7a5e1a75b43bcc4cf68a256978f482d37b"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c2fe154acac06b388bdce117fd0d7a5e1a75b43bcc4cf68a256978f482d37b"
    sha256 cellar: :any_skip_relocation, monterey:       "f6c2fe154acac06b388bdce117fd0d7a5e1a75b43bcc4cf68a256978f482d37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c88f795a9f8679628b8d97ee37ea139c8fd5d9efabc18d777448f07c6fe8243"
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