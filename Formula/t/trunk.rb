class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.18.6.tar.gz"
  sha256 "4d0602df875ff26ac9d3473f4818075b645ce2680aaa8b7e6d217c8c9f65f186"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51db539d60da2320c968dac2bbc4f547a2d1cd3d7c504d5c9694cf8e7f6e31f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d938d46e5d15563b4d8b69d3753d843e6353bf06235838400285dd848562d38a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f16886e848a1a47e64a7a16d145fe877a4a78db003f31ee85b0d3d33ae6808"
    sha256 cellar: :any_skip_relocation, sonoma:         "15dc736232e45a74470506a8bf35d06c1b4e1e9513fef154e223f00851b723e4"
    sha256 cellar: :any_skip_relocation, ventura:        "a28d760febaad45c39cfe561e6a708d39a8ce76bddebb862736c4bd9cc2f6f88"
    sha256 cellar: :any_skip_relocation, monterey:       "8b63e966cbb6248c5d009e56cfdabc7dabc89bfe55880398c69715f470f46cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd72b8daebdcc5e79898fa975fea22b2d51f187da44007bccd63041d2664fbec"
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