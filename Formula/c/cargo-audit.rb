class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https:rustsec.org"
  url "https:github.comRustSecrustsecarchiverefstagscargo-auditv0.19.0.tar.gz"
  sha256 "0fbf088247ab2aa0da9d42dcf8be4bd10d05296e6599a2ae91a94d25aba6d37b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comRustSecrustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-auditv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43521354b4eeb0504d354f4eba1e15ed7cbb7614e2209c90fbfbcfc599eeadf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "233141d0e90a9177e317fbfc05b6d1ec2ab8dbe7ca52769b495d6d2aacf3729c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc939d96d504ff43f4ebf2644090723a078122a843b18c6817a4ada22f222d03"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fdefc4833b2f2d99dc6ace4b23f48ee6371f64857d0dc5a8136fb501c1be169"
    sha256 cellar: :any_skip_relocation, ventura:        "7abc1e0fc341bf1b69ef24e61d15afb4be5512e8b26d1bc6a5241f9aa1c2bfe1"
    sha256 cellar: :any_skip_relocation, monterey:       "817dad187598e5e3c70ccec09214dcea71f7eda24bb696d0aee4052637990788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb5c4dd6069ee71e8d43b8dfc2c0fb34519ad9887ba72e6dec350768ae76edc"
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