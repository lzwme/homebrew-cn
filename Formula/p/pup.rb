class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.24.0/pup_1.24.0_source.tar.gz"
  sha256 "5a3085fbc5a9161f1b797525e5fbcf9e775929d23b8ff62b0a66bc0f8731cd03"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69a6aedf5d621b977c99784c4ecabb4d34a223a2366c149a97422ca146c4c5fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f13f9ca52cfe82b6bf3c3c20723427e9965b2152ee2c6fc6592831f3f5d8a54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a0f1407ca31b0586302b809e3cf93356e296f33c33802069bd56d6bbfa003b0"
    sha256 cellar: :any,                 arm64_linux:       "cd796964bc446c70f1c3ad8d8483a0520ac4c11ea9fe2976ac632803778d249e"
    sha256 cellar: :any,                 x86_64_linux:      "feedc2891da9be8513e8b22caeb3f111b2558331737d36ccea1d082df1b89299"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end