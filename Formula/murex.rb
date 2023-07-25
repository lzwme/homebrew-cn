class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.4.9100.tar.gz"
  sha256 "a5db352fe289309fdfc72ca4ed564755817da9d080e8c200520a340796ad2848"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a2d7e32914d0b3475d7d580e05972f91a1702032e230499c98db5a3e6c0a58c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b2006c390c30d4615fb089acb2788173f4d7141fd78f1824ccfd93db32e78cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e63fd129c0e192e07ea437a17ea73e774bf5610a6b3527ad9d55fc29b0026e9e"
    sha256 cellar: :any_skip_relocation, ventura:        "17ade56238f50b060532f3b0da004021c11abf08510e888effc8c8f9db3c63a8"
    sha256 cellar: :any_skip_relocation, monterey:       "6723d1c25d41c68f71aeebb297dfd2803a15416e93758f6dba9d720d3d414583"
    sha256 cellar: :any_skip_relocation, big_sur:        "081fe2d53da3a16769a128dd1fb8c6072ae2a33ee20beb6df54acc14e5313aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e40642daf7db9f51d981a2813bce0b321b8e657e5777529891a177cb1ee13e75"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end