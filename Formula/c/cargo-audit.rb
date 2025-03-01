class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https:rustsec.org"
  url "https:github.comrustsecrustsecarchiverefstagscargo-auditv0.21.2.tar.gz"
  sha256 "caf8914af7f95ebb45590c95b5f9bfd71bd6f9f57c1ffcf69dc9d20f0430e578"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrustsecrustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-auditv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1026c4533d050573d5230be68488a2e1eebd86511c1e81875556ab85881a39fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ec648c09d2370224edb174d362c38328dc785531eb14824ee190cbf84e30fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89259c963f1c699e2772d82def2c258ec0cbb5ef966838c3d75027b4eb98be11"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e3f669b10268c7b6c28841cfd249296c7c0a16fbc70fd3e60885dc465f313a"
    sha256 cellar: :any_skip_relocation, ventura:       "36bd51b1a6055e1fbf190e1cf2c746b83056a9f6d32eab537800c0938461572e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01871584f36e0bfd0da80de286069e9102f34c4098618cb461d7457c6364d63"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-audit")
    # test cargo-audit
    pkgshare.install "cargo-audittestssupport"
  end

  test do
    output = shell_output("#{bin}cargo-audit audit 2>&1", 2)
    assert_path_exists HOMEBREW_CACHE"cargo_cacheadvisory-db"
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}supportbase64_vuln.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}cargo-audit audit 2>&1", 1)
  end
end