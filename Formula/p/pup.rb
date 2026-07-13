class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "39761db452ac5852ebcb18c6d496305c54cc4d7bf04279c8e7cdd7a72744be9c"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57f3a91783cbd9ff444b07f9c1713048096ee85517cbd8c4dc19316fdd80a60a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a639a826055d48d5dcd9758fc59e4119eaa066a33c63b43bd899395b3c5a7216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6514c51f16282100f0d43d638632f97d69bf64520ae13962380125fa377afd9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42f4437c44a672058cf9eb5d84e0091964737248d50d09e56b4e179ed314811"
    sha256 cellar: :any,                 arm64_linux:   "02f5ec60b8ab9bef702d5fe0f5b463545538cde1b9d119749660d760c05ace60"
    sha256 cellar: :any,                 x86_64_linux:  "2d64fbc5e4583b63a96ebe9aed3a14d3ba6141dc068eca5fca4057f4e99e6001"
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