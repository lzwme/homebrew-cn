class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://ghproxy.com/https://github.com/in-toto/witness/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "03bb27c4f751aa259f02993fecef08ff3a295018165a886d640a8951eb3fcd02"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b758e2bab3db9871bd6bc186045abcf32cd8f689decfd50ecc4fea2b433478d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c314219273d42f35194a7d40e905a21787dd3feb4149c7412e29b15a3dbfc952"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8a4fe9e62c16c76256f12f05477b6b82f66eaa9da065a9d3599669db025e186"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ed0c481715c5233d93d7dbebc8ca8a7005077238ede5048cfcc50804b4063a6"
    sha256 cellar: :any_skip_relocation, ventura:        "57bf1552e03713d867f6e4236f503eb1f1a2c2ce8a2c79e2f03876206e886aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "6d97f1b975e0eae9e7a8cba3725acfe83c2fb60f66642235df237bed1d0ebc4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b4089dc36268b905a34f751bd4227a7767f5a4da2c4d3c2a176729db3e9bad7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/testifysec/witness/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"witness", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witness version")

    system "openssl", "genrsa", "-out", "buildkey.pem", "2048"
    system "openssl", "rsa", "-in", "buildkey.pem", "-outform", "PEM", "-pubout", "-out", "buildpublic.pem"
    system "#{bin}/witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath/"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https://witness.dev/attestations/product/v0.1\",", output
  end
end