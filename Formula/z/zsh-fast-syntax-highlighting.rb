class ZshFastSyntaxHighlighting < Formula
  desc "Feature-rich syntax highlighting for Zsh"
  homepage "https://github.com/zdharma-continuum/fast-syntax-highlighting"
  url "https://ghfast.top/https://github.com/zdharma-continuum/fast-syntax-highlighting/archive/refs/tags/v1.56.tar.gz"
  sha256 "9e5045510ef86beae658b5fcf58e7b6c76f5b63788498b956d54bc1038faa806"
  license "BSD-3-Clause"
  head "https://github.com/zdharma-continuum/fast-syntax-highlighting.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92d65197b6bbc546272e39daecc43aec0a884213f6fee5d4b44982e8dc57242e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92d65197b6bbc546272e39daecc43aec0a884213f6fee5d4b44982e8dc57242e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92d65197b6bbc546272e39daecc43aec0a884213f6fee5d4b44982e8dc57242e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ef6826ede6de08521db68f3088cf67f4de7b5026f9df28a4ec53b48aa11a54b"
    sha256 cellar: :any_skip_relocation, ventura:       "9ef6826ede6de08521db68f3088cf67f4de7b5026f9df28a4ec53b48aa11a54b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92d65197b6bbc546272e39daecc43aec0a884213f6fee5d4b44982e8dc57242e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d65197b6bbc546272e39daecc43aec0a884213f6fee5d4b44982e8dc57242e"
  end

  uses_from_macos "zsh" => [:build, :test]

  def install
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate the syntax highlighting, add the following at the end of your .zshrc:
        source #{opt_pkgshare}/fast-syntax-highlighting.plugin.zsh
    EOS
  end

  test do
    test_script = testpath/"script.zsh"
    test_script.write <<~ZSH
      #!/usr/bin/env zsh
      source #{pkgshare}/fast-syntax-highlighting.plugin.zsh
      printf '%s' ${FAST_HIGHLIGHT_STYLES+yes}
    ZSH
    assert_match "yes", shell_output("zsh #{test_script}")
  end
end