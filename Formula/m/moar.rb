class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "ad63e3f8ae048700d54d9bdbeb5408c5e9f9708e0979e6c9f6cb43139727aa7f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85abfe8bb2f27022be9be8b254b06d57d30fe8a98c40adedb5bdfb27c22146f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85abfe8bb2f27022be9be8b254b06d57d30fe8a98c40adedb5bdfb27c22146f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85abfe8bb2f27022be9be8b254b06d57d30fe8a98c40adedb5bdfb27c22146f9"
    sha256 cellar: :any_skip_relocation, ventura:        "91d58d9e92608e103e611f494cfd158bcac2d6cffc5045626fabaa9925c0954a"
    sha256 cellar: :any_skip_relocation, monterey:       "91d58d9e92608e103e611f494cfd158bcac2d6cffc5045626fabaa9925c0954a"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d58d9e92608e103e611f494cfd158bcac2d6cffc5045626fabaa9925c0954a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91faf0d8ae8924cdd3e84dcdd5717da3ff2ea61a1480bba37c395f97ca0917f8"
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