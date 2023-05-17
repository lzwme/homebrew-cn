class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.1.5200.tar.gz"
  sha256 "ce3c836ed0b7ad8775a7b17933063093554024b39c41e9a5fb7580176e340813"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5962d0cfb4b58341daf9dfb680ebbc1297d9a7ad42b271bde993551711f2bb23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23304839188bb1cf70ef163e88b3452641195e1951c3f95daf44a10ca5c6c9fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa2b24296c66151a6d8227ace4ef75a210984bf9d170a6de17856ce683f044f"
    sha256 cellar: :any_skip_relocation, ventura:        "d7694dbf136ce46b42e0695bd1c73e633d93ab07fff5affe63e5de48cc710e24"
    sha256 cellar: :any_skip_relocation, monterey:       "ecad6391764b1900eec35cd84d8cc567bf95528b3229b1fa5cdf7202c144b8c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "33da18823985eedb9e5833f1ca99cebc6e0d4898bc8eda2b45f4c90c90b73be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fbee3fc41a4f47245f024ad777e211dc3a3e7637319814f199e553a2bae6be7"
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