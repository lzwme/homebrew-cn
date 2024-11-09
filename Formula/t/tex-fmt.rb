class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https:github.comWGUNDERWOODtex-fmt"
  url "https:github.comWGUNDERWOODtex-fmtarchiverefstagsv0.4.6.tar.gz"
  sha256 "2b7c7f6759007fa0671b9e324b089f5fd70fe6ffdb63388152681217db44b2ae"
  license "MIT"
  head "https:github.comWGUNDERWOODtex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb34c52677db7fb7550f8b1fb8f7929ce3ebe878ae7c40a908910b2dce0a22b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b36a877d20a23d3dd125687249b2443b849e2cc861a4a6a252d54a46995e9555"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8e0e09eec157e097b59f92a843dbaca6d5c4cc00c2276b807b512aa43df8ee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a42d1a3e86e57004e02099dc83cfe34cb7855025cf662b35b97ddac1ea29ab7"
    sha256 cellar: :any_skip_relocation, ventura:       "02302e6fbe21bb550ac45a4d0bec1be3f4eff0b2427ccd907d9a48e88d55c733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e8bf49bdec450809a5ecebbae8a78f73c629dd77f8fd101757d3a52b2305a4a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"test.tex").write <<~TEX
      \\documentclass{article}
      \\title{tex-fmt Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
      \\item Hello
      \\item World
      \\end{itemize}
      \\end{document}
    TEX

    assert_equal <<~TEX, shell_output("#{bin}tex-fmt --print #{testpath}test.tex").chomp
      \\documentclass{article}
      \\title{tex-fmt Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
        \\item Hello
        \\item World
      \\end{itemize}
      \\end{document}
    TEX

    assert_match version.to_s, shell_output("#{bin}tex-fmt --version")
  end
end