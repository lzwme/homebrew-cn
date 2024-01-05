class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.21.0.tar.gz"
  sha256 "bf6dea93cffdf818ebbc9f2039518b2e98927227128195f42609e56447b86cda"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "320558536a69b5b2f0811ba5d8ab7a239719df9d47d6e5505c95a6e7d41e968e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "320558536a69b5b2f0811ba5d8ab7a239719df9d47d6e5505c95a6e7d41e968e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "320558536a69b5b2f0811ba5d8ab7a239719df9d47d6e5505c95a6e7d41e968e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7e23fa5a979fddd9f2e1495d458de12a7d563d0a25bd24ee176ff7ad3efe4f2"
    sha256 cellar: :any_skip_relocation, ventura:        "f7e23fa5a979fddd9f2e1495d458de12a7d563d0a25bd24ee176ff7ad3efe4f2"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e23fa5a979fddd9f2e1495d458de12a7d563d0a25bd24ee176ff7ad3efe4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b8c3e648085047072a2b32e297e5296119d6346d83e67aa7cbb7dccbef1ea2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end