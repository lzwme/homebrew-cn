class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e81f1fe6d785a0a3428e683d9ad2fae5b795ba127fc4e2c2f3026d973d12c74b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13e0630e08e50a97e3612a29a58a87408f006f1ca7ff826e83b016e4b89b56cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "164c6d091fcd3a6a0b4424d658fb0f847790e9055d4b27c1178eccb521b9f146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05093d6519f2dec05771c62f1a97676e3ce9ef64fa27b5bf76ce72aa2fe3357a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8acbb0d3c658861372ac65d02fcef3bd3f2aa35d4ff3e7d1b44549a7707e75b9"
    sha256 cellar: :any,                 arm64_linux:   "29dc60b7a795b4dccd23310b17be13a520dced7995abe1efdec4b83997a6bc3a"
    sha256 cellar: :any,                 x86_64_linux:  "aac972efb3ae6d76eec60026d5c790db37b74a2de6f8661a9a328e7eb85a03ec"
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