class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.59.0.crate"
  sha256 "cbfcbf4e23943074d270667b94b83f45bef80eaf48628d2d1d97fa66ce0f180e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3099eb5ae1886cfa4130b0257059cdb9d22477170d472ffe3e58a852a06668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b0c77cbd8a7c2e7a0c68eab9e9c524d0ab1443f61b3626d041fb590732ff7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcdcc68df470c2173ca2df0c75d23355136aaa471831d994b0e5dcc1c462e9c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "46007aba2878890b43e05eb7ae8582a8efbc42d39d4b04458ca0b8ef85561246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e12d422e207aeb7ad0baa69c8242eae2e815ae81cfe22186bc586855e83302d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f129d29689f91a2a1b84c98a3c4ea20d057c52fd23e5bf33a6fa426b81be77a2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end