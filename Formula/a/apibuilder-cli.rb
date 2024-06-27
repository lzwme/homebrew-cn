class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https:www.apibuilder.io"
  url "https:github.comapicollectiveapibuilder-cliarchiverefstags0.1.46.tar.gz"
  sha256 "8189b26f158d30ac09a8855fffa72fbaadbcb777eb3c1fca23e2532f333ba228"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, sonoma:         "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, ventura:        "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, monterey:       "79672b8fc92835089a5ce4e1ac85aca4dddea758b5201b870e077cb5ac8e0553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "145081bf4bf85d25e14c330e68e03e19a02d9b97cf5e207b459ed7667577596d"
  end

  uses_from_macos "ruby"

  def install
    system ".install.sh", prefix
  end

  test do
    (testpath"config").write <<~EOS
      [default]
      token = abcd1234
    EOS
    assert_match "Profile default:",
                 shell_output("#{bin}read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}apibuilder", 1)
  end
end