class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.18.2.tar.gz"
  sha256 "b27f4297413c19d453ee2b7ae905cd85e03cb06bd1021290187eec56b88831e1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ea960ec2b8f34d0488cc2cd3952adf13f01583dcf37747c62d46c52a234af87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3269dc969cf6fe33e116a3d305277a6e8a1cccb3f13abdfd7cb51b9114fc289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e96e5643d913b18336dc8ec70ed36c1dcafd14d6099466e09e75a9be1e8dcf4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad372252c5150fc3eaa03112f65fb6d167a11e57b25a9ca6f99e810d40c21bf4"
    sha256 cellar: :any_skip_relocation, ventura:        "bb40ded1398cf731cf441c4a5ef81873a0509e008d09b55c3edcc2c4453fd6c4"
    sha256 cellar: :any_skip_relocation, monterey:       "005103ab4c3502ba0b46b6eb1d6a3ba4ca2105720083f0fb3c867b2289ad55cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56594929b8ce44ee559411672abff411e78ed1295b88285bc26252466ad1d03"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}trunk config show")
  end
end