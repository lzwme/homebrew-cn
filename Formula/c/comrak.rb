class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https:github.comkivikakkcomrak"
  url "https:github.comkivikakkcomrakarchiverefstagsv0.36.0.tar.gz"
  sha256 "2192177a284992fcd437f6c248f70f0ca9df7e62aadc281ff049731c29ff3e10"
  license "BSD-2-Clause"
  head "https:github.comkivikakkcomrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0277b844b2b72772060d4e9e512e2766e85e6be81670765ff2b046fed63f0659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f342591433ab74e398b2309f812c185c49e9077f9a32168e2dbbc678848bd0c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3de0e5fbae08f90e2fa0f2b2292ce181616ebfefe77648c51a5db1da7142d434"
    sha256 cellar: :any_skip_relocation, sonoma:        "48cbd4221b625462ca6958b788a5624996db9af8153b52cbc359b611a26020e8"
    sha256 cellar: :any_skip_relocation, ventura:       "8b054cb812585d2271d28c437dc98ddbe7d00e934ca6f2bfb3ef01ea2ff1eb7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6bd5757cb90cca03f42ed8391e7eb3a147c43cfc49d73eeab33f23a5cea053a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8f9fffb3c14d60f6a87416bb1e199c2b98eb37f9c8be9cc6e7430625bdf77e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}comrak --version")

    (testpath"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}comrak test.md")
    assert_match "<h1>Hello, World!<h1>", output
    assert_match "<p>This is a test of the <strong>comrak<strong> Markdown parser.<p>", output
  end
end