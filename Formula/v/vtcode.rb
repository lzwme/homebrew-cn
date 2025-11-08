class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.42.11.crate"
  sha256 "10ae2fe0205a4749ba6519394ef7495e52a42d53446331284f1cbe2ffdfc7bce"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "603450da93d6708e63b534b9d3739160154b82099ee65f25948cacbc54364316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d916c534cb9b14f39fe9c8b5fecbc1b741c572dac67d23d33e9ba1ba46039727"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "740584c4dcbffedf612ae38a32ccd649607504fd429bc99e22433613cc913dc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c12cfe062608461b92cc95aceb002caff49cd3b9cef3387683b34e2186caf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757e75a29722e6b477ced73367c49767699c28a2ba528e82b9a6248a275c38a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c69d25c0c804cf7a4f35c3628a7a4a9d285647da5921c0abbc873daed469acc"
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