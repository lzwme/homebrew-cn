class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.117.5.crate"
  sha256 "994895c0b59dc794d8ec3153cfc4c0d53bd3a726740261023b01a5f3ac2763a0"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9b7c182bcb3fba2092f6750519112c088715b9d898934722c259f4c585947e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55fd2b1adace46556c5b5248b37cfbf224bf600d8dc0f3ff70689abfa2b03fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a622b0ca338714af94c08b315daaff0b4fcc69a8e9ca45626266c8d5bec2987"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d74c0331ae8569d3f713648dbff974ce666469be791349e7f3705a5d2f9c6b3"
    sha256 cellar: :any,                 arm64_linux:   "ddb1f2c5a300b0eba3b636647f9c5ab12c85bd18bdfe528e53d53988edc7814f"
    sha256 cellar: :any,                 x86_64_linux:  "b34f45c9623e4fa3bae6a76597250afeb91e42eac6a50cbfca5ed46020d11a84"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end