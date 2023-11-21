class Hex < Formula
  desc "Futuristic take on hexdump"
  homepage "https://github.com/sitkevij/hex"
  url "https://ghproxy.com/https://github.com/sitkevij/hex/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7159eb1bf14d3c55aeb260cc5fb857fc8c91aca36fec3d22123aa22ecbab0509"
  license "MIT"
  head "https://github.com/sitkevij/hex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dd9c0615db9ccb98760fb65e88a9186344be2c9e7d29d0d2fe6611dccc0523f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c62a623a1ef8a0f05ad516c808273c280138caaf93254fd73ab75b78a8bd13e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ca7c372250ca8038c0dd5366f40bc840919693451b50389460e54b24b89041"
    sha256 cellar: :any_skip_relocation, sonoma:         "75aab541165020ddfb189b70f556d02e20d5a610d786d83d7a61c2f0f40e2947"
    sha256 cellar: :any_skip_relocation, ventura:        "bbd6e66c9c7be08ac12c14417a01ee6f0fad644761f6900f6e77b813f96f38ee"
    sha256 cellar: :any_skip_relocation, monterey:       "6c3ebbc3732606adbbb30f7f77bfe6bacbaba67fe9a1bd734f90a76ccc77a4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd0e1c2f352562dc8167235b72631296712633a66f67ad41655fc7027d6d16b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiny.txt").write("il")
    output = shell_output("#{bin}/hx tiny.txt")
    assert_match "0x000000: 0x69 0x6c", output

    output = shell_output("#{bin}/hx -ar -c8 tiny.txt")
    expected = <<~EOS
      let ARRAY: [u8; 2] = [
          0x69, 0x6c
      ];
    EOS
    assert_equal expected, output

    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end