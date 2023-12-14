class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "0a9143be12f6848750bdd77b2bd5d71c5b46e0d98d9987970b5c9ace8133f888"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7494eb7c13f54f0aabc1a00a1c1f5948fba95bceb186267932d86f0e6a5afb35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7494eb7c13f54f0aabc1a00a1c1f5948fba95bceb186267932d86f0e6a5afb35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7494eb7c13f54f0aabc1a00a1c1f5948fba95bceb186267932d86f0e6a5afb35"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b507c8aeed43843a2baa9f4c2e88fa5a7f2f4a033359795a8381748347243e"
    sha256 cellar: :any_skip_relocation, ventura:        "14b507c8aeed43843a2baa9f4c2e88fa5a7f2f4a033359795a8381748347243e"
    sha256 cellar: :any_skip_relocation, monterey:       "14b507c8aeed43843a2baa9f4c2e88fa5a7f2f4a033359795a8381748347243e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df90f621b7ceaa1448a9a77068d15aeb8a29d7c254b082f0db9d6ef455eb5446"
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