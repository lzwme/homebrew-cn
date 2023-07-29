class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghproxy.com/https://github.com/go-nv/goenv/archive/2.1.1.tar.gz"
  sha256 "4879470b41ea1ca4dccb8f2889f5bd37355526a106db434650be70cb9f5c4517"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "700e255e5701fe87d6e1018c53f9bf08f2f7cf583596a411ad12cf58554a3e45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "700e255e5701fe87d6e1018c53f9bf08f2f7cf583596a411ad12cf58554a3e45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "700e255e5701fe87d6e1018c53f9bf08f2f7cf583596a411ad12cf58554a3e45"
    sha256 cellar: :any_skip_relocation, ventura:        "7f7c8744bdb61f6da7fd67a3fa8746c9ae75fff164a8dc7f05d2734274a338b4"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7c8744bdb61f6da7fd67a3fa8746c9ae75fff164a8dc7f05d2734274a338b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f7c8744bdb61f6da7fd67a3fa8746c9ae75fff164a8dc7f05d2734274a338b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304e0a90916d585deb8ec0d05829809dc797041d673244990a91b2207f8edd29"
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