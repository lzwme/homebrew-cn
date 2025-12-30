class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.55.1.crate"
  sha256 "8250a2b3fba204dff5926f01e6a71cc4cd5da39a6fc44cad66df901d2bda45b1"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91764017fcc711cfc8f73662b985d4187aba01bc6257d0a04c65d0f29f8f8ca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927705403b9ecd66d0f37f25e63de852530e6c36e5a4191f6076bcdd187dc959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9706b79f553a4b5735b485edf4e4cbb933e5798cc7795bd2b306c64d81c9fe72"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cb316d2e9aa4be06e025a1c46e9882dcff3946b08ef1401abf25c4fe9d74a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af7d3045ef3ab6ad9e9b755d3650e136dbf07218e182c833b2423fbd9b73f631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d89513061491cc01975424887335297ae3d59059a868c51658acf7e957606d07"
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