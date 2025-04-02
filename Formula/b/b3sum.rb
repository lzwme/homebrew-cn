class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.8.0.tar.gz"
  sha256 "b9f565adc6e2c8c813dafd6d5406a71382f7ac6aa3250b19e9d8a68c457fd769"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc76e77b79f081752bf24e55bc6da5bde1939238f66f00929f8e687b947af80b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73af9c2d5c2b2f3a3d680012e437bd21803ae095e51c69e3ea81bdf73c97df1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c01f2e56c805914aefab281a5f19c7d5fe7c24242a54546c33a5de0cd870942"
    sha256 cellar: :any_skip_relocation, sonoma:        "807f9ea7bf8042379997d49bc6e037fe316f5d6457991e999a9d1c7bfc82592d"
    sha256 cellar: :any_skip_relocation, ventura:       "3322117fdfaa468ca7156fd2d470eadaa30dc61be765014c0be18c2c801e1da1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c489ea9d8f5bb37e8c17fb21f128dcc78c8be83aac7985bd25017ebc4f30f27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc06c8ffe196a14c2441a57e22bc80d5c46450cee1221c5a6a4d849ec9b8a7ee"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end