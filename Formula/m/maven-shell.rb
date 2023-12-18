class MavenShell < Formula
  desc "Shell for Maven"
  homepage "https:github.comjdillonmvnsh"
  url "https:search.maven.orgremotecontent?filepath=orgsonatypemavenshelldistmvnsh-assembly1.1.0mvnsh-assembly-1.1.0-bin.tar.gz"
  sha256 "584008d726bf6f90271f4ccd03b549773cbbe62ba7e92bf131e67df3ac5a41ac"
  license "EPL-1.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orgsonatypemavenshelldistmvnsh-assemblymaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07937b1a530b436e89a72f73244f782228dc02ee2b31e761e052e5367704a39e"
  end

  def install
    # Remove windows files.
    rm_f Dir["bin*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec"binmvnsh"
  end
end