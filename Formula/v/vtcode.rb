class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.88.0.crate"
  sha256 "8958d497a9c92cd945bcf938a460ea612050483a50af00e0ccf469ca43dea8c6"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7d2ebb19be7a2076b06364a71ffd494947f935e16ebe7d6612186bcaea4051e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc18435d8c6de8f4b776854929f35003528073e7fdfd8effdf49a40a26cb10ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa908240f485a8244e5b3bcbfd9cdf505ed7356d67a43325b28d53b91917e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0370067a0e4d2706b29ca218bbc3cf6e92fa366fda6f6d4e12876c19a3155c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b73507424edc0de0d034bec83f621f492196fcd2170f6e7aed371710ce9f8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70087685a0739bca5196f170bd364435c8334917448cf0593725e34087553982"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end