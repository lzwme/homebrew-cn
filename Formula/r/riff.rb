class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://ghproxy.com/https://github.com/walles/riff/archive/2.26.0.tar.gz"
  sha256 "89c9670054121186e3d0b492a315c79e94e5adf965b64f6197249f175df33082"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7064892f260f6d3be280da11d9367aa62f180cab755455fb96c1ffbf77752704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "411c80ee8d996b97cc9031b75a1bd3f0d4a7143d7c8916eeb01872c21c9af58b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59996725890eeae4d4d1d95112f566bcf19fe7742bcff47ab17b0268bd3a126e"
    sha256 cellar: :any_skip_relocation, ventura:        "bcc2c2d6ff8237917317df41f32ccc33218124576e4318be47f087f0c60157cc"
    sha256 cellar: :any_skip_relocation, monterey:       "cd37e8753c2374c17d19957e709cd277286770351417a9170264f46e158c361f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d555860c3999a3926ff784edb7d27b45d945d64f4d3e32565b63b1438ef524b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "996f8c20395fd99f1cd8a6d100712e89ef6726153d3472cb8d53a25643e6429b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end