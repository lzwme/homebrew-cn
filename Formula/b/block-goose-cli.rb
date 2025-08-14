class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "87c18a6dce39daf535451b15bc9f98e0eb95f0c86df805a08f4748187340d361"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b67622fb2f020cc7ac1abcbfca9d000e8a41090d57342b439bc7f9f2a2d59c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b308d0ce458bbdbe075a5857960b576cb81b9ae42f412ee85bd4800434a8ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c17b22839e8ebedbafabb72fe4648ef355060afd36c2370954e21454eabca4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bd0368fb43ddf2d8dc0c528e783ee5b4245e8bb6653991a91c912ce7bd72d6c"
    sha256 cellar: :any_skip_relocation, ventura:       "0680e4b6e6c6d819f85eb4b5bba0dfb9d9c89c5b19bb02129f2b4f8cc8531d4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ffb274abe12a1e2df99569ab4e09e3ce0f54833485d683edd02adfb4e537ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca4ca764dc9aa73e957bac33fb89a73a5f814eeeb6dd5b3c5d97e006e5feccb"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end