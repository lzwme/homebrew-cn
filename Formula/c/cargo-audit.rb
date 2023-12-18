class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https:rustsec.org"
  url "https:github.comRustSecrustsecarchiverefstagscargo-auditv0.18.3.tar.gz"
  sha256 "db58c773e4a6d308ec71ce7119435c9139d271bf60bcf0e42b6ba9bb1aa6879f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comRustSecrustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-auditv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9758319536509280ba39c66c29c687e0223cc8fa8764c5dd44b8b7e017225ea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a529d721d21a7e11d68ec20c24802df989ec598b20e7140813c7a2c43102e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b78fae46cb7dc70d4da4b9703aa3ec984a6276b019c3ea3913e940bb1105942"
    sha256 cellar: :any_skip_relocation, sonoma:         "54882fd630e84539c6b80111ce59fa67ea7533df83620c269614fe3a79cb3322"
    sha256 cellar: :any_skip_relocation, ventura:        "3d844bc4e806f86f2f3078ff0a905db2b510e042ae3acc8a2f67f726a8209383"
    sha256 cellar: :any_skip_relocation, monterey:       "0309b03d08be9c78cba79c6e3323c97737a517e71165c0a19aa4d27dd91c854b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c37c016072ad2fcfa488554f9a58f086dcddb2c2cd29ae4049506bdcb276e9f1"
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