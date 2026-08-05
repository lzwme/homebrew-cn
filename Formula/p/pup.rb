class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "e8f648de7c3b32c624d749baf621aae1f5ce3375a5d69607d773215ca98be527"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81521865f9c1c8cfab1e2f2f7b0247285221f0930e539a833e7bb54bb32de531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2566dcf389c6018f6c49b36adc7ec1898a41d9ec5e93bc076f5968d260f6a39e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef1ad29eab02abb99ec07ad8d6e5e5d460f3acad6a6ad6556e57a8999e800d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f0f7f7adc852327bf0c2e8b696cdf49939c415934e2555538c41b2e6d8bf97e"
    sha256 cellar: :any,                 arm64_linux:   "f9ef8648182e09f0a46afcc2b41695d484ec71c08b8916c12e6146e2cba3bf8e"
    sha256 cellar: :any,                 x86_64_linux:  "345e970d77a7bc011311ee004e10b60740adfc437d42f280b6a2d2909b864b21"
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