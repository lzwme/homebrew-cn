class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.6.0.tar.gz"
  sha256 "cc6839962144126bc6cc1cde89a50c3bb000b42a93d7e5295b1414d9bdf70c12"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbefb5b4354c704b356f90d3a5fe0340940ac3a30985fddf2bd9188bd179e6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8000691d184f32303ce8331bbe48e53f8f2ee16562afaab94a82b9bcc3f580c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be4ac2df9948ef8891027aba01a14fec63c82f0ac91be0be5327c374f6a033d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f63c32ad268ea59102275a6636928bf92fb99104bc834f8602bbf85faae71ee"
    sha256 cellar: :any_skip_relocation, ventura:       "7580fdb189977c8d23d01caa4edebb256d03f312bc8163205640e78436b8a48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a94459a01a8cac6d82d8e8268ea230c184f08a0f2da3c9340a7020f290db927"
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