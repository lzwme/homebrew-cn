class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.3.7.tar.gz"
  sha256 "5b3a17e98fd134e3b803125ab0e2ecfb0f55b7a2a26e8f401d9ed7c1c43beb12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a54cf9628c14e784afcf334f168404c2d8b9c39346c4418cd34d25eb6bfedab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f982e1ea5f638ad8c063a89baccc1df4b1b6d4774cedbec8f70b7da7322d80f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57f26343cab7282844cf64afa4d9e1a2623f715945e7fad1bf358daae05fc7f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad0144d422baa5295da1e63742a6722f37cde5019aea1ac846a9fa0fd03ff2d"
    sha256 cellar: :any_skip_relocation, ventura:       "710c9bb83f8549c038ebb26e5ca05c498b9846a01584c4bb1238b233989119fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad9e5f79a60fbefcbcb50a70fad6fe44866584ad5c6b4a3ff4afc4bdf113d273"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end