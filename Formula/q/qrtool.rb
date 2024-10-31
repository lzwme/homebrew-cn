class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://gitlab.com/sorairolake/qrtool"
  url "https://gitlab.com/sorairolake/qrtool/-/archive/v0.11.6/qrtool-v0.11.6.tar.bz2"
  sha256 "37b4dee60af2cf6211ce7439b64d38d7196462415cf998b70f30f16c3fdb7fb7"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://gitlab.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e6870560b41a8b3f0f0c3e02097798599005db8d579d0cbec020221deec1da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad03e4c7fac90b5fa20fe7cbb7604732e2b0835c2b70ea98e5e9ad471893d869"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6884bc646daa28647b11baf9ba80d10d6d000e76ff454e33fe13dfba909e367"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c338b94172639b4697729961ac223e2733499aa60a2055aaeae172131b3c403"
    sha256 cellar: :any_skip_relocation, ventura:       "4c88772f05cc8dac9aeea084bc02024e0f45f6f3617ecb913e1e73ed65d317b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13215d2360180c17ea0a606f91f31e9b5d0be3750674e52f2ea1f7be83bc6c8d"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    outdir = Dir["target/release/build/qrtool-*/out"].first
    man1.install Dir["#{outdir}/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_predicate testpath/"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end