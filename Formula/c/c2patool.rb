class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.16.tar.gz"
  sha256 "fdb1d80b740b30ff9948b4ef5e0c74bca107442ae9984a58d0e5b10e5461d0c4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e97a3ceba96e1f7d171e047de7f0a636ca3b9786ffb242cd7248e1067bca908d"
    sha256 cellar: :any,                 arm64_sequoia: "a1c18fc9797a4c700d36f0a2856615e6340ca3cb241678b38d09cc5f46e13b30"
    sha256 cellar: :any,                 arm64_sonoma:  "226d34e1ec7eba3e24b833a2a610f217066b577fefa9c9d4f8b21360657c8b4b"
    sha256 cellar: :any,                 sonoma:        "37bca9b79d509c8e39dc926ffd415f26cbb0fa3ee8f3b5f4e8bbb46054b3e353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b96686130045056bbf6f8eaebefcc592cc7689f710d279cff43af6f744ca085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d660624606e93b5b5b2cca2528ca531b9e933623061a455916e23e78bc6a650"
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