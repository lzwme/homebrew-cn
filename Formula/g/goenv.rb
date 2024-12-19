class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.12.tar.gz"
  sha256 "5cbc2634145e480529d7191d3bff308aac8a20cc0a8790d4c85ac7e2a686d541"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
    sha256 cellar: :any_skip_relocation, sonoma:        "62cf6a53c1d573674d2a8fb356d13c3cb19606a94c63aad3452991f1b7058587"
    sha256 cellar: :any_skip_relocation, ventura:       "62cf6a53c1d573674d2a8fb356d13c3cb19606a94c63aad3452991f1b7058587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7fa38db94544b1166e7623348c155518dbd2618a41d35f1dbd6a075e42f447"
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