class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghproxy.com/https://github.com/go-nv/goenv/archive/2.1.5.tar.gz"
  sha256 "09f9f3857144cc3172619700d2fc70f3a2f85114c5ca7d6993bb1a418e581935"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecc8df1871383c5436987568aadd17467ebaafade75bd9be6cdd93907fc8d86d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecc8df1871383c5436987568aadd17467ebaafade75bd9be6cdd93907fc8d86d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc8df1871383c5436987568aadd17467ebaafade75bd9be6cdd93907fc8d86d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7de573477e10ab3b39e19d5745ac968fb2e53425e073e0cae0dfe2989d05ddb5"
    sha256 cellar: :any_skip_relocation, ventura:        "7de573477e10ab3b39e19d5745ac968fb2e53425e073e0cae0dfe2989d05ddb5"
    sha256 cellar: :any_skip_relocation, monterey:       "7de573477e10ab3b39e19d5745ac968fb2e53425e073e0cae0dfe2989d05ddb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc8df1871383c5436987568aadd17467ebaafade75bd9be6cdd93907fc8d86d"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end