class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://ghproxy.com/https://github.com/RustSec/rustsec/archive/cargo-audit/v0.18.0.tar.gz"
  sha256 "dd84ed79a113ef42d03075da8ffd2d896713b17ea01af7e23238a90da6f83382"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21c1876592fc9a44b3f241b265cb5fbec87104a1a93fe40ced515c776977ca35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b5096c24cc86bfd8c33fdf82dcb6514b9d10a154cb4b8d1c50fd95f4818fba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a4ee8255da50c4bca11d4b8d030fb7c19ed7bb302cd4df8b0793143d8b72f73"
    sha256 cellar: :any_skip_relocation, ventura:        "f209cd66934ef958a70653ae7db2430890abf0f6446563883ee40dc95913691f"
    sha256 cellar: :any_skip_relocation, monterey:       "bb564f5490612e7fd0db45c3b0099f083d857801dc2ef97a6eb5f0940702f4ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "fccd54d37005af5d2e22de3c17314b65e8a741103aae8d1c90bb2b77884037bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e45a72a5b62539d01ab641a547e0cd57f7c5966c72250fdfde4ea919ad7d19fb"
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
    pkgshare.install "cargo-audit/tests/support"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end