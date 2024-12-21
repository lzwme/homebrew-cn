class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.16.tar.gz"
  sha256 "569edfaed8df3de3e7b3bf871a7aa0688fb8e5562cacc3dc0883637219b260da"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec0eba9ad0ac1f8be9330fa654718e7d82dbf7e7886c3ea55739a1f554d13eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec0eba9ad0ac1f8be9330fa654718e7d82dbf7e7886c3ea55739a1f554d13eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dec0eba9ad0ac1f8be9330fa654718e7d82dbf7e7886c3ea55739a1f554d13eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "90a65db9a96a6a87907464dced2a023c34dbfc6406c40d8a56d9527d278ee901"
    sha256 cellar: :any_skip_relocation, ventura:       "90a65db9a96a6a87907464dced2a023c34dbfc6406c40d8a56d9527d278ee901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec0eba9ad0ac1f8be9330fa654718e7d82dbf7e7886c3ea55739a1f554d13eb"
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