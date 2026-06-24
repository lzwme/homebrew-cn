class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "621b11985207bc51e830baeb90ea9fb5c8c25708c6d43d884f1ca87f16a7c1bb"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3685d17f5233feceb35996701b9defed5b2dece9e93d548122034d8659cd85fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "294450d4b556b3d2b266084207dfc5eec6515453ee7b9153295298e786b70006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e3c7a27129df0b626e84042f358a048bfc2fac75a563e9540fdd7b30753119"
    sha256 cellar: :any_skip_relocation, sonoma:        "7406cd28b0ec07426bc8c954a0096347cf475056f16a23f1d6cd2a52d23bb42c"
    sha256 cellar: :any,                 arm64_linux:   "5fb5f71903569b120ac9d26f688788f79c0b92fc5a57b745d72364cfcb4fe5a7"
    sha256 cellar: :any,                 x86_64_linux:  "b33f8d24255e63a14242ba993593344f6e55c7be179e9d2da4f0a1705893b2ee"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
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