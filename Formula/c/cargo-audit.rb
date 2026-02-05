class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://ghfast.top/https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v0.22.1.tar.gz"
  sha256 "262d42fcca5db8629b6220d84e62e7ffda913846a36089a847ffe276e6b09446"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustsec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6e1da58874562864d3ddf655bc8e0bc37aabafcae816ee8e8783aad19934220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77c19a55bbd46c4b6f164860bce8773545619d7bc33386339e55f06e876b3521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1122954b7f865130a467e057ec4b08095a439b7fd78e88b3f742743f225d7f53"
    sha256 cellar: :any_skip_relocation, sonoma:        "008da23bccc764848791d2d1c2b8989a01cd2302d076dc92b62165be76644ecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd429416d65215512e1edff026556bb643d92eab15a641225deeb85404a1fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feddcd6bb9aebd8baba3b4d9a6bb0a1c2fdb5809eab759b979c25d41ec11db2d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-audit")
    # test cargo-audit
    pkgshare.install "cargo-audit/tests/support/base64_vuln"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_path_exists HOMEBREW_CACHE/"cargo_cache/advisory-db"
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end