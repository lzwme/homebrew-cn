class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.17.0/pup_1.17.0_source.tar.gz"
  sha256 "feed3d22589ec5f2e522f358d317e16d79864181b630f6ecf602818a160460a3"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c9e51c4d0cd51a1276cde0adc007a5db64b9778695194bebd382cf5fc2a6d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555f025319b0446bd84ca9c6c183c39a0f583e3002ab6e5f04cd2e92fdd77320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c4fb1e738b04883b9f1ee5063529421709a7da3c4ac3973f294d6ef3189d26c"
    sha256 cellar: :any,                 arm64_linux:   "623e47c2d4f40d5d1c81f1eb85adfc4af137353e49f7b18be4d87520385cab58"
    sha256 cellar: :any,                 x86_64_linux:  "c8fbc4bfcc808cfcd9db07b083124373b5d89fcf478128b8cc95e9e942cf464d"
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