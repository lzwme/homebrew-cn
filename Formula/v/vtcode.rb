class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.123.0.crate"
  sha256 "792ba451b16566bc22ebd71a6017d3c0293d5cb16d7395879697deff90fa4c75"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e1b331bfdd00d44bbd404e8257c4097769e60226dab81edfb176827f0ed7db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806fe2011cee3bcd8af674a99613a62d11a3cf1b7992bca5515b14835437209b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "188dd554f2314684ec30dc44044e5f4ceeef7d4ac6ed6e09ce18e5b470629c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d2ea385636cef43c8d13249c65e83644872d754523c21b5ffc8b68cc9cda607"
    sha256 cellar: :any,                 arm64_linux:   "f7b9caddf781deb1f93980b649a1731361b08346239bbc1d0e84e1513fe46925"
    sha256 cellar: :any,                 x86_64_linux:  "917b84519b1e8c0d63e7180f078743cd31928967303fd0ae1fe08da88c23e405"
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
    assert_match "OPENAI", output
  end
end