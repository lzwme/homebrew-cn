class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.41.tar.gz"
  sha256 "e74afbf5bfe60c7ede88e383ccaaae4e7cd9df0dd2d837cdd018f73f203fec7f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9c090e10e876157facde5e881705107008aa35be1ffa1d057b7630ebb68a238"
    sha256 cellar: :any,                 arm64_sequoia: "fda74edd38c21ca93481ff5492253fbaa06bbdc98030e1011f701cb1cca5b6f0"
    sha256 cellar: :any,                 arm64_sonoma:  "c868d8cbc78836ce54418a90d4251e9df4f1b560fc4b2d9072b4230e58f8b26b"
    sha256 cellar: :any,                 sonoma:        "3fb691f069dc4e4310bafc5f0a86efcbaeae30a08a3bc607c00a830f4b1edb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "274e6e72d5684fbb12198b3cf924b9eacc5de692064984e34171d47a9200bc6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c639d4ad9d2e234c09d7c8b1c1fd35cc6ebe40e80393e12b19aa8050b72354f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end