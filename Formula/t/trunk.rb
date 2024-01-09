class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.18.4.tar.gz"
  sha256 "024a0ac8beadd5f010c38c986ce430cf98adba15f069183b9902f6e27a7d3efa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4475d8f33e0c64f961f9ed208ba75c6fc85c79dac382fb497fb05d05ec1a72c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1586cdd9c7b54192eaf737f88ff989fb71762f4a9743ef589b2304bd2998dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe3681830cce527871379dc1ac374167b486a4df74e30b0a589f531c5fcb0516"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcfe3561ddc7e81fcf1e21f2109df3766d665ae50d83d3a25eec79e4be1efe0b"
    sha256 cellar: :any_skip_relocation, ventura:        "ced8d55319aee36ff0c49e08c00584f4a427454c60dc98f6a632c5cb236386e9"
    sha256 cellar: :any_skip_relocation, monterey:       "0bcf0ef510bb55b9e1d89e368f5cdd590c4269b91b2b17b840b8bb0046fcd027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e494374dc0c6730ba661f2fc53c8ff05dc2d67eda174fd92d735a0480b32b582"
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