class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "2abca0b19b573e071b92e24b384a4d5864ad7cf3dc925ec42cd60f2e78c25da6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20d23c3bbe31da83a746ace0c9f7fcc217832dff9e9a2058507a61b8baaae270"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20d23c3bbe31da83a746ace0c9f7fcc217832dff9e9a2058507a61b8baaae270"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d23c3bbe31da83a746ace0c9f7fcc217832dff9e9a2058507a61b8baaae270"
    sha256 cellar: :any_skip_relocation, sonoma:         "f22362da7c6397a9e879d81f0c6dbbe4669e97ea17cfdeaf2c249b2171cb7e66"
    sha256 cellar: :any_skip_relocation, ventura:        "f22362da7c6397a9e879d81f0c6dbbe4669e97ea17cfdeaf2c249b2171cb7e66"
    sha256 cellar: :any_skip_relocation, monterey:       "f22362da7c6397a9e879d81f0c6dbbe4669e97ea17cfdeaf2c249b2171cb7e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264a1458a4c3863f34c1e2b2fb405e0f0f3b6415d2587ea1dcf67e963b067186"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end