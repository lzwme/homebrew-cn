class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://ghproxy.com/https://github.com/filiptibell/lune/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "e8191df5d6844026772cc7afab1083235a265c506474c4c4dee0a7724b04f775"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c0216d2bdb9294728c316a059f9baae58ea811070eca531b43ac1acb02529df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9cefd8902e53f9de92145b5631d66b057a3966b712bc4c589c6faf59ab8dbbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e84f1f6a9e4843d8ade0427cc81915bb4da1a577900687306334c8d18dd20d9"
    sha256 cellar: :any_skip_relocation, ventura:        "8caa14adc49429021e37e484215bc824c2adaf78327b852a53acfbf81fefd9eb"
    sha256 cellar: :any_skip_relocation, monterey:       "217e425db66a50868b06d9e3f714e89b557a410cbb10da8f400b424e1f68b91c"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaa243487b95aafc43d122e885e991fc626f411e8536ba1c095fb6da015ef906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa74cdec1e75d0b56518a6fac59b5b3e152dc7f04e9b36f05dbab61c31496a21"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune test.lua").chomp
  end
end