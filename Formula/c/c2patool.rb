class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.65.tar.gz"
  sha256 "f28a3004eceaea4d80839c3ee995f332919e830f980b20ff0b70c2af95527ac1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "152b95f7ceb9e9204b52753263958329d6e9c2ac778f3c62e66ef90a71130def"
    sha256 cellar: :any, arm64_sequoia: "b42a02fd17282f170ce1e9dd2d8598c7d3d7619b5d2fdfc93f7d63bd9b14e709"
    sha256 cellar: :any, arm64_sonoma:  "ab6a6507c6473824972ce0bf407c091a29b55b44827c26729f42b892668ca0df"
    sha256 cellar: :any, sonoma:        "92c2769bc64aa3fe930d6ff5089236571cf7e851021d431f7b1864d677c2b178"
    sha256 cellar: :any, arm64_linux:   "c38c7518f56ae64c20f6ec6e7ff37eb9a9f182954a3c5836c1b1b87ff05ed7d3"
    sha256 cellar: :any, x86_64_linux:  "197b483fee967583a30f66ec1d15f11b430755d944e5fbadbe85754f3b1efa31"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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