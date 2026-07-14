class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.72.tar.gz"
  sha256 "66e2991476e8a6962b73f5d0e8e2aa10b3625128acc40ad5d73e840a5f877594"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "87aadd7346ce8cc9c3715f775ccc20cfcf814748dd4b1352586610354618e756"
    sha256 cellar: :any, arm64_sequoia: "916e372d05f0ed5bc2840bd1ea976131341fdde2764f864d92eab165bbb82000"
    sha256 cellar: :any, arm64_sonoma:  "e0e419206858bff504da22beeb049955738c5defa950e8d124229085944e617d"
    sha256 cellar: :any, sonoma:        "dc14c93caeba49c43cd1e66901260171f3ee742a810fca6ba7b507a702678949"
    sha256 cellar: :any, arm64_linux:   "57413009844450e3d94a68678fea2da46d6150d357c7b35039c3e97388aa2966"
    sha256 cellar: :any, x86_64_linux:  "f3264c80ce42984225d8d49eb3a9936cd9c54a22f64761af18eaac1c764e0ebb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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