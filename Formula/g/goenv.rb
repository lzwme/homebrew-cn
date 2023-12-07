class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghproxy.com/https://github.com/go-nv/goenv/archive/refs/tags/2.1.9.tar.gz"
  sha256 "c47d1a3483c8daf0c2f6d0381b3c5b6320584b1fc719e22a4a6f6b5b892ca82c"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48b68254680d5057d5b4e57dd6efce59ba66e337ba8a3951323e1b5a9211a049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48b68254680d5057d5b4e57dd6efce59ba66e337ba8a3951323e1b5a9211a049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48b68254680d5057d5b4e57dd6efce59ba66e337ba8a3951323e1b5a9211a049"
    sha256 cellar: :any_skip_relocation, sonoma:         "defe6d1af139f9cc9c99a8668562828f248e13f5c20c323be19d9b19ffac90b2"
    sha256 cellar: :any_skip_relocation, ventura:        "defe6d1af139f9cc9c99a8668562828f248e13f5c20c323be19d9b19ffac90b2"
    sha256 cellar: :any_skip_relocation, monterey:       "defe6d1af139f9cc9c99a8668562828f248e13f5c20c323be19d9b19ffac90b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b68254680d5057d5b4e57dd6efce59ba66e337ba8a3951323e1b5a9211a049"
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