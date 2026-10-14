class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.27.0/pup_1.27.0_source.tar.gz"
  sha256 "58d3c7a0451f0b2dd8ef28ff48086f71b82b3e308a732c0be893f7a26b2a0969"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2090bf178755eb84fb20a8d654fa8bc1a8d26baedf2c0d2f1bc12a14eb5ffc56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffbd4978cb13167ed0a9b33b4fc62b20eec22cce59de9b787183df359995409e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5ae81db3f4538a5c7db08a492d761fe65a2ebebbbc7a5f4c2c3bbbd0146fe2d"
    sha256 cellar: :any,                 arm64_linux:       "e9142d7199eb6cbd933b3d72d6bf964f1704be7d3bcb2fc942f606ad3d7d5a42"
    sha256 cellar: :any,                 x86_64_linux:      "5901ea7950607fd51b3235df6adb0262967a0bb1afcc645d47b50629ea6aa291"
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