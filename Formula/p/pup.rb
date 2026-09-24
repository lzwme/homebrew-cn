class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.23.2/pup_1.23.2_source.tar.gz"
  sha256 "f696ce7e72f3fb26a158f06fca6a78af34f5bd9ae46400e999915cfe84a9956b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "295b815c0757035dc8905b9bda8b107628926686da654a70eeb2e297ffb1f1a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e55d5b62264609aa581b1f19eee7b62342f034f96224756942b78a37944c5d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cddd6d731e4f4c5ba783b416534dd1b4120a40cc7b62913b70eab58db533f86e"
    sha256 cellar: :any,                 arm64_linux:       "f910dddd8c2355700896518bf9bcce9d083d3ca0569e136ebc12a065987a0947"
    sha256 cellar: :any,                 x86_64_linux:      "03a02f94dbfd6d3a3eb6e0169aa009810a4136a9050e1b1c9d5715dcebae5458"
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