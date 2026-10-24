class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://ghfast.top/https://github.com/jdx/packslip/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "12a5c3faab6c363654134b484273f539abc91bc85976fe63dc77eae533a7b9d0"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13c23f0f9094d566e9bcfa4ad0a8efa4689e6c4decd2aa2a80589f89bd3049a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a61353abcfbb59a3eacb213b7a2d26c8013bec09df1127d2f0ca31359c654f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "804aeff806559452130df95b95948e95cde1972f371fb53a3585966336db1ef7"
    sha256 cellar: :any,                 arm64_linux:       "981c4085f7229a534594d1760a4c71aeed005e743075b0ca3a30a859c76e358b"
    sha256 cellar: :any,                 x86_64_linux:      "3d56a654fe86b96d1ff0fc86060554cf5c122c1c0f2c43b880264dc1288b369c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"packslip", "completion")
    man1.install "packslip.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packslip --version")

    system bin/"packslip", "keygen", "--out", "brew.key"
    (testpath/"brewtest").write "brewed"
    system "tar", "-czf", "brewtest-1.0.0-linux-x64.tar.gz", "brewtest"
    system bin/"packslip", "create", "--project", "example.com/brewtest", "--version", "1.0.0",
           "--key", "brew.key", "--no-log", "--url-base", "https://example.com/1.0.0",
           "--bin", "brewtest", "--out", "dist", "brewtest-1.0.0-linux-x64.tar.gz"

    output = shell_output("#{bin}/packslip verify --pubkey brew.pub --allow-unlogged " \
                          "--artifact brewtest-1.0.0-linux-x64.tar.gz dist/packslip.sigstore.json")
    assert_match "ok: example.com/brewtest 1.0.0", output
  end
end