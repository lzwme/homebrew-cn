class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.10.6/pup_1.10.6_source.tar.gz"
  sha256 "95ae9c96515926fbd817cc9144d9b83e3b0541aa604703cdd7de7c21daabc22f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "254e44deb2277f6580f61b670e7ec411389682ac1785844801b344c2d98b1daa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "208bece35434eaa2a4ae76ecb1d8df32f0f02d7eaf95b710c09201e86dcbb5cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db2b92df403b74c63152a77d1079167d159ac4c9f0ced86e8ac95ae606f274d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c0c00d1fe482331325e3d36ae038c199d5a72c8892fd3c78d539733f469ccc7"
    sha256 cellar: :any,                 arm64_linux:   "88750d14b184514b301d9046689b0a86cb6aa6994d36d5e6edb516721e3433ce"
    sha256 cellar: :any,                 x86_64_linux:  "1d298ca45bd0b892c5d4135ff3c1d111f49955caa692c16e74669704f8ecbce2"
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