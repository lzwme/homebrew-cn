class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://ghfast.top/https://github.com/in-toto/witness/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ec0e023353092ea749eac8c1452119b0ec097ba74952ca96c073293dd2689d9b"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38a93bd6e749ef5b5dcc6b8923c738bb56203d7cf5315bd7f726fea4299b2910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963caad7e32d28af56b823b83019423adb5266e9848bd5e44c9dbb37153768a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9981aa9ca6ac0e278eda0a3fe305ad353b5d99f029fe4508d57f4c23554c690"
    sha256 cellar: :any_skip_relocation, sonoma:        "882e66c68b5902d14f4dc3943f931dd22313f336c15aa3813700b32b01319a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc01fbbffe6b5d82ae26d4f135d64ab7c0d43d04fdb3d9c9ada1bca5836c01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7784e36883044ab8bbef1f6af7b840a42d97dd91525604d5c294d04c2a997bed"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/in-toto/witness/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"witness", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witness version")

    system "openssl", "genrsa", "-out", "buildkey.pem", "2048"
    system "openssl", "rsa", "-in", "buildkey.pem", "-outform", "PEM", "-pubout", "-out", "buildpublic.pem"
    system bin/"witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath/"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https://witness.dev/attestations/product/v0.1\",", output
  end
end