class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghproxy.com/https://github.com/go-nv/goenv/archive/2.1.3.tar.gz"
  sha256 "e35f5cd7fe1f5283c6888ea99888509110d1707ca390ceca484ba34712cd8eab"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e9196ee2b40a159e7c832351b64c07224a2c4aed8000cb8988cfa14b0305529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e9196ee2b40a159e7c832351b64c07224a2c4aed8000cb8988cfa14b0305529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e9196ee2b40a159e7c832351b64c07224a2c4aed8000cb8988cfa14b0305529"
    sha256 cellar: :any_skip_relocation, ventura:        "44d27b2665526fac4b8f1d40d3479e6f5c929757ed875fc5cf002ad5c60cb131"
    sha256 cellar: :any_skip_relocation, monterey:       "44d27b2665526fac4b8f1d40d3479e6f5c929757ed875fc5cf002ad5c60cb131"
    sha256 cellar: :any_skip_relocation, big_sur:        "44d27b2665526fac4b8f1d40d3479e6f5c929757ed875fc5cf002ad5c60cb131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad588feaeeadd16f8b105f3cc0af3ea1aef0dcb6a7c9cea5826d22cd370987e3"
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