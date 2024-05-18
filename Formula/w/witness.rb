class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https:witness.dev"
  url "https:github.comin-totowitnessarchiverefstagsv0.4.0.tar.gz"
  sha256 "9fc50844292afd333fc47de4858e38a9af5d92deeec5a804d6831f2bb6a15f5f"
  license "Apache-2.0"
  head "https:github.comin-totowitness.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b94c89af16800641e2bd0ceacc53ca8bbedd5a5df1170ba2e620949772d17d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d096a520ba138920288d2a3a3f6a515ce5515e0937b00443528c51ebb8eea10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4e727d83da1923b354970984e1583ad2040eb1a94689f950104698dcc27dad2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f66410acd71e2b7bbef7c518d0a80394b5804a3016224fbe4090938fd1526f68"
    sha256 cellar: :any_skip_relocation, ventura:        "84f30d20a3322731a5180233f9fbd5941a1e44410910a5936ea056cb16b360ea"
    sha256 cellar: :any_skip_relocation, monterey:       "18af13c25d7a60ec005cd55a7dfca47ec91e8a96b48454265de4cd94e2abfcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4794e07cea3b875f6f913c5a0596442174345bb9531bf577251c562addb9237b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comin-totowitnesscmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"witness", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}witness version")

    system "openssl", "genrsa", "-out", "buildkey.pem", "2048"
    system "openssl", "rsa", "-in", "buildkey.pem", "-outform", "PEM", "-pubout", "-out", "buildpublic.pem"
    system "#{bin}witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https:witness.devattestationsproductv0.1\",", output
  end
end