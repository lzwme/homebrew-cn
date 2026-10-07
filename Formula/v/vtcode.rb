class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.173.0.crate"
  sha256 "52bad43dcb612759375d034072662b2e8bb93b3fe60ad38dd71a5446825f3e38"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "166dd2b28f0954686a0e186f441d51b54f9a5ee30528e7de84a2ae0c7f28460c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0167284465256f9074d76cb3cdb60292acb08d8226a062e9e8ec7968433ea50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be5c166c3dd26de91b12c5bd36aa34d9c83ce4587bf4f549295d19fcdb04b838"
    sha256 cellar: :any,                 arm64_linux:       "056185825403b6ca274ee98d14fb42f4d630dc5a9007dafe5060cbeff2f0a402"
    sha256 cellar: :any,                 x86_64_linux:      "4bf8e36efa61822ead2dc1b0dc17f33bd832509eae5fe76a0fde87c47f09a9b7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end