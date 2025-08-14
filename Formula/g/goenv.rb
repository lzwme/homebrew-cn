class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/2.2.28.tar.gz"
  sha256 "6dfb6ec4696327afd5cd21f40ffe1268e304e1ad025e45727f5248cd8a4f5d3b"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c02f6ccabdabe84f83b596bddf6caee495e4a7dee2a3c1feee140c3bfaefea1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c02f6ccabdabe84f83b596bddf6caee495e4a7dee2a3c1feee140c3bfaefea1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c02f6ccabdabe84f83b596bddf6caee495e4a7dee2a3c1feee140c3bfaefea1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e489087fc9b34c6432823b1822510809291a35f01c9395684454b047ce6091c"
    sha256 cellar: :any_skip_relocation, ventura:       "6e489087fc9b34c6432823b1822510809291a35f01c9395684454b047ce6091c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c02f6ccabdabe84f83b596bddf6caee495e4a7dee2a3c1feee140c3bfaefea1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02f6ccabdabe84f83b596bddf6caee495e4a7dee2a3c1feee140c3bfaefea1f"
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