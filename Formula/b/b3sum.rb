class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.7.0.tar.gz"
  sha256 "59bb6f42ecf1bd136b40eaffe40232fc76488b03954ef25cb588404b8d66a7e0"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc662b47799c127022e71d604a3ac7efccc23efb98ab49b1f4d8e29a8bebd9c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a74d75b8d2ffb37176fb2ed223ac8e6079a005837f92e17c17d437bed173016"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5ab6625d37db481615f66d238f7a4783a5899e9ded037657580ed4ad30054cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d942581b73802e665d8edbeb6f9c058e3a57fa0d07a2e85b03e828302847a5ea"
    sha256 cellar: :any_skip_relocation, ventura:       "97758b5713002a547f370893ac4cbb02fc0c9749bd229f31787be1395a048865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12bd1b3f6b33e1a74c494ba410e0416a5b5b9a237618747621164dc9cd5ad63"
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