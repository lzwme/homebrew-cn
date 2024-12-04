class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https:github.commrjackwillshavn"
  url "https:github.commrjackwillshavnarchiverefstagsv0.1.17.tar.gz"
  sha256 "c80b296a9e1d6f5226cfa38866899e65f59fd5e88274065b40fdd223d74beece"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529cd3837bcfaf70c1c85cf02ceec8b859ee86bbec84661009653144b75f66ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07737f8e7c3dce49a7a02b349256644d0cd3f2745eb5878263a57cf6c168af8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b9c409478d1c9b4206cf166c3936e86cccea34a537a398af44cea38b5a3dd5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca7ea879c322e3b7e65eda0f29edfcaf9a2fceab27362d8ce8b5c6444086a8a9"
    sha256 cellar: :any_skip_relocation, ventura:       "6367db8e0d272eb5cc6c762ccf7aa855540676542127327a2c08e4b562fd1064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d71bab390b801706923c46ff1d8d1adc5e1d95b576d5a64d51f4539ee1ce4b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}havn --version")
  end
end