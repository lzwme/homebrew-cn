class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.22.tar.gz"
  sha256 "7508de421dcfd26ef9f3f557fca3a7f82454aa13555d401c1c9e5c8f25234d14"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15faf9092efbd5134d7ab4514fb08088613a9d6529c6ad572c8e43bae9863a41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15faf9092efbd5134d7ab4514fb08088613a9d6529c6ad572c8e43bae9863a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15faf9092efbd5134d7ab4514fb08088613a9d6529c6ad572c8e43bae9863a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1716a357c066fedb9eaedefa0a19976285131a213984bc058c6e811566908e7"
    sha256 cellar: :any_skip_relocation, ventura:       "b1716a357c066fedb9eaedefa0a19976285131a213984bc058c6e811566908e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15faf9092efbd5134d7ab4514fb08088613a9d6529c6ad572c8e43bae9863a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15faf9092efbd5134d7ab4514fb08088613a9d6529c6ad572c8e43bae9863a41"
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