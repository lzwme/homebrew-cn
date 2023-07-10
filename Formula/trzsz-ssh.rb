class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "9f2ca4424b00cbab059b12fca0b7b2629323befefcbc55f7f072f77f095ee979"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a13734595b12e92d1bbe9c553d914bb96885439c759c15f663489114c2f762bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a13734595b12e92d1bbe9c553d914bb96885439c759c15f663489114c2f762bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a13734595b12e92d1bbe9c553d914bb96885439c759c15f663489114c2f762bc"
    sha256 cellar: :any_skip_relocation, ventura:        "8678592a79c847e37b647a161400a117339a97a180942675550f6dbef99623ee"
    sha256 cellar: :any_skip_relocation, monterey:       "8678592a79c847e37b647a161400a117339a97a180942675550f6dbef99623ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "8678592a79c847e37b647a161400a117339a97a180942675550f6dbef99623ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70e5dc531c495de4b36e293acdebbcff2fedbe5b7eabe3df9cfeb071ccd37a19"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh --version")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}/tssh -L 123", 255)
  end
end