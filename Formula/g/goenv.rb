class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.2.tar.gz"
  sha256 "b32a7874c52a6884b13246d4b7f44d0ddd2169f803fb17df94133d3e3a6b6f53"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c384940223ec2b8dbfa5b42700f2cfe158bf111ebf06f527dbb6185b86d4bc58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c384940223ec2b8dbfa5b42700f2cfe158bf111ebf06f527dbb6185b86d4bc58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c384940223ec2b8dbfa5b42700f2cfe158bf111ebf06f527dbb6185b86d4bc58"
    sha256 cellar: :any_skip_relocation, sonoma:         "2484fe9619ec087cc2794d969e5b8e1fb271ddb239d894e78ebc649e051d58c4"
    sha256 cellar: :any_skip_relocation, ventura:        "2484fe9619ec087cc2794d969e5b8e1fb271ddb239d894e78ebc649e051d58c4"
    sha256 cellar: :any_skip_relocation, monterey:       "2484fe9619ec087cc2794d969e5b8e1fb271ddb239d894e78ebc649e051d58c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c384940223ec2b8dbfa5b42700f2cfe158bf111ebf06f527dbb6185b86d4bc58"
  end

  def install
    inreplace_files = [
      "libexecgoenv",
      "pluginsgo-buildinstall.sh",
      "testgoenv.bats",
      "testtest_helper.bash",
    ]
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}pluginsgo-buildbin#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}goenv help")
  end
end