class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "6362b4bceb295b5caac6760c4ca06331be8d2af018cb3126f4a3ccafc8aff982"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7464fd9d94a1d6672f237281ba74c53c63ec30b2fb71664f7e2da2548abf0fe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8b0a7438b06020935285c35ac230c8017616fcc0eb00b811e04fbb20326dbfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c80a59b457fd864a5dbd2f0cba91ac34e4ed1df19ab560a0ad492a098e3ea2b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "17f7257744a894b2e76ae743c940155c2f53686e4ce1046567466a44b97ea360"
    sha256 cellar: :any,                 arm64_linux:   "db4d4d2c4918f0c383e76fd28a0722da1d2a85f9526e175c9eaa8f96a4554547"
    sha256 cellar: :any,                 x86_64_linux:  "67175fecf0eb2fab259612da2f6130d3e5a9a0a380295eced87f70be88b80656"
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