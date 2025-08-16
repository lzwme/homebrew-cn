class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.20.1.tar.gz"
  sha256 "6ece8c31cbb28a61034debda9c65ae9301489efe2e83b8220926260c4ca8f8ca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec18f32ab989bcfd06bf136dabd6c069dbc3aedc3c692e23fd5b434899195736"
    sha256 cellar: :any,                 arm64_sonoma:  "70c5e2984dbafb35110ddb21e83462b802295ecf2379a3e5f49a084d9b4756c6"
    sha256 cellar: :any,                 arm64_ventura: "da80f39698603faa364f5528bad1506e7c088a57e3ff0955523ecb5bcd9eb3d7"
    sha256 cellar: :any,                 sonoma:        "592e1a0e027d81742829ae3c392ece33d3b061d8b16aae6050ca3d8c345f3b20"
    sha256 cellar: :any,                 ventura:       "d3dd8e068d747c3c4c440cd1f7a920feee19df4ebcf376583abe4513220ec1c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7374432f6d0b954660585519cb226e0c85e4116e60cb0c34432dc55988d972c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312c5bf83d4eb36b2915f24f67d288f6eecf24b4fc1b5ab77497f1d7e35f8889"
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