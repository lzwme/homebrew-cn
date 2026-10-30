class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v2.3.7/pup_2.3.7_source.tar.gz"
  sha256 "954339f37c241a13ff278821506edc466040b33eae038bcb29f3253d3e2f0b5b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f2afcc3662a61f1cc2f3e957d72d18aae2dd2c2e6bcdf86371cbb9a5d069ada"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3c0d52b64d775f2dc915130feadcfea8f91851a73629ca30ef41c44ad368e30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2446b4cfc263e4a088e63f3a7088ab9ec4d35703b0d109675ba099d268fd817"
    sha256 cellar: :any,                 arm64_linux:       "b4c782e5bdf1a46364cefa90b8f064c827ea32b2612f4cb85bb377cf9ffc8088"
    sha256 cellar: :any,                 x86_64_linux:      "ca22cb48a30d4e77bf874d2de4a2e8b95ec328254287e47264a7e119f39f025a"
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