class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/2.2.31.tar.gz"
  sha256 "e232021d4105af30c7ab483f1bf75a7e698fb83a75f1de12aa2790f83f9e8401"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5b1ca9fba91270076c2b5c9eb0faadd8f8de0545e32ad7ca53edccc22afcbc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5b1ca9fba91270076c2b5c9eb0faadd8f8de0545e32ad7ca53edccc22afcbc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b1ca9fba91270076c2b5c9eb0faadd8f8de0545e32ad7ca53edccc22afcbc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b78d0a19d123af626e6c412e37131e8f2882cddcc3a5318be327bc54068808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b1ca9fba91270076c2b5c9eb0faadd8f8de0545e32ad7ca53edccc22afcbc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b1ca9fba91270076c2b5c9eb0faadd8f8de0545e32ad7ca53edccc22afcbc4"
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