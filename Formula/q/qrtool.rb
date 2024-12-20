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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e47b6269582d8257d04edd95b7ee8590250be7939b776e5d1ad93f0ced6be97b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f63c7b57c58201ce6060d3a22908c16e5421b196b8da499e5e314bb7e54e280f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "128756d73531417dfc062cdd8f7ab0747e389887a2adc3106593d67c5235f498"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c9f89a5c2fbbdd3281eeec991027bb25a072d8823061307938a2da77c45d12c"
    sha256 cellar: :any_skip_relocation, ventura:       "e55875fe9512c5bee0e316b1b827f57a6ded26d3318a4ef4fa22a024c821d865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b629b69b2dbd059b27cfc6c33cf2cdcdc169960f2641d19e74986a257a02d12"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"qrtool", "--generate-completion")

    outdir = Dir["target/release/build/qrtool-*/out"].first
    man1.install Dir["#{outdir}/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_predicate testpath/"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end