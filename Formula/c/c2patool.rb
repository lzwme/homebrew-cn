class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.54.tar.gz"
  sha256 "858f9d59f84c631d4952edc8fbfaa8cacdc01006f2ab46cb72c8d1520b660d50"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0249e4cea1d6356b8222358e4844f7c600b21ad4561a16c104a65edc1f115e8"
    sha256 cellar: :any,                 arm64_sequoia: "2c2f64fe9562701d73aee7f81c5ca7de3607f41424d28d108a15e705b058af46"
    sha256 cellar: :any,                 arm64_sonoma:  "ba0ec4fb5e424a5f26378ca65448bdd65ce7fd06a2adc45ccfbee41d8c6b78f7"
    sha256 cellar: :any,                 sonoma:        "7b83b978a9fb86fdf10183a9b81f28074205ef52ae2eb322735fd491d7e9e2d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5989d35032e110ea165de48a041d2812234a4d1cce3c1d6ef0e94f71c972f958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007b7c6b7627c6edfa97372ccbabbfec07a2a8cf078a8bbe907cf86e46a00539"
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