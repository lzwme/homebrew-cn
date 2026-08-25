class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.13.0/pup_1.13.0_source.tar.gz"
  sha256 "a32dc964538cb0ea249d3bfb36adc40b45d0e83d08425ec7085ff1c2c4b4482f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eecd8ab753779736cfc2334ff1aa9692e0b1b7146d6698fdbb98e53719be2bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ad3a210b47a781ea9e7526aa20fa9c94b9f37faefa9b2a8c1ac2176c6529cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a623cfae7ea049b54cd28376d6a401b1799a85be4c4003a2c1452297e33e670"
    sha256 cellar: :any_skip_relocation, sonoma:        "f33a67a04e23b8dfeb12fc2e9d8458c905f01ddb42493b0646913226d91fcb55"
    sha256 cellar: :any,                 arm64_linux:   "7382a2eccdde501c01e797c7a18bd1ebbb2049645507956ab72e7149d8b3c88d"
    sha256 cellar: :any,                 x86_64_linux:  "5e3b7731e6d4bef58018dc23bf787122014f85a57a82499393af9e8c77c0b600"
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