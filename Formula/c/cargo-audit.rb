class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https:rustsec.org"
  url "https:github.comrustsecrustsecarchiverefstagscargo-auditv0.21.0.tar.gz"
  sha256 "343242874edd00c2aa49c7481af0c4735ebcf682d04710f0c02a56a9015f6092"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrustsecrustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-auditv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d8b35b5ed9aaaa17e8b67f037a02823477b81f0510880469dfb19e8dfdac53b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a71c3d0f60e9a03f06736ef8da99cd3972bb843c4ee0a0eec5d5c9616ed309c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6147d9a1d314491ec1944b9c14a812a781ba0f0f98e8efe536eb162b54dc0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4869aa826a6e54647453f3ff38902de373f533a2c9a9bb8e020109c0364b9f5"
    sha256 cellar: :any_skip_relocation, ventura:       "f7ebf6b00cfce35080e30e96ee1f42d81e2ce50dc56909c1109dcfa3684fe751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99578791cd07f067b67f092cd7e6362dffbff0ed7e542ce5bc055d25cf2bc8bf"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-audit")
    # test cargo-audit
    pkgshare.install "cargo-audittestssupport"
  end

  test do
    output = shell_output("#{bin}cargo-audit audit 2>&1", 2)
    assert_predicate HOMEBREW_CACHE"cargo_cacheadvisory-db", :exist?
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}supportbase64_vuln.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}cargo-audit audit 2>&1", 1)
  end
end