class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.18.1.tar.gz"
  sha256 "47cb8adb3e002d94db9a75e0e0ba87524f43cd833b9d13eafb53128555a06cd2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77f35d1d13a43b25d72d6c744150a12281862ad8e9b94e4597cd0e0c5ed450de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b3536e62e852bad3c2441bee9b2f6db81584fca9103c3b5d9a15131e1de9a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3125b8beab4fc40d7973257af3c86d35e051c0863e6d1d294e5cac4f4b96f1e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ece61badd67029a2efccfbf717f007efab18d8928a0a9c970b5b6814a3d1687"
    sha256 cellar: :any_skip_relocation, ventura:        "cf378c60503568bc62719dacb0c3e43f42f6cfe28a3e0d8d826f4da73dce46d7"
    sha256 cellar: :any_skip_relocation, monterey:       "dec1a5f10f825706ab3a13e0c336053ef49bf53c1461784654015575b18e4a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ff4aec292e86696b556c8fa280cdf4c35198fc1527b01a99be1b0576a59c6c"
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