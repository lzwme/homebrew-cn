class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.0.tar.gz"
  sha256 "fc497cf8a8234308f5f3db0f97fa8c916515ca8fe67c77639bad0595055c6a4f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb76f68c24e5f7b539b530cad56d2fc2198f7f0215e39bf33566162a273569b7"
    sha256 cellar: :any, arm64_sequoia: "f92c95d3db290f5e708bef36168633b69061c7be3d20c90041799595d695056d"
    sha256 cellar: :any, arm64_sonoma:  "fe405a388fa382ad12b9b3ff079f43a319d5febe4732dbe449591b7e7aa674eb"
    sha256 cellar: :any, sonoma:        "0bacd4a8a8949b91dd31f34f93cf1caf1b4add63ea68ec6d360a46520518cb64"
    sha256 cellar: :any, arm64_linux:   "19bfc19684a0936524d7b9a4f2931d8ac9fe5431cec77792cfae882e30c9bc7f"
    sha256 cellar: :any, x86_64_linux:  "571eebcfeecca72fc62938eb23c6704cffa5c30c0e66e0e4a80913a828cea580"
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