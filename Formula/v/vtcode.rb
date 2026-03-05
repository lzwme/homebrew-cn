class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.86.5.crate"
  sha256 "dd0a9584d116c57fe8bef95f485b4c11f424a070d77e1182466b8e98af662146"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f69a80ef4da4cdaab9a58913f734155e16bd8b01b911177d14a418680fe5434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b2c3fa914ea4a870f2908f62e795618ecfc575e8422897187da6fdfb9f164b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "321e4a87ec150b68c7cae7d7c0b70aa3a606cbeba7ff50a6abbe7f4636b2670e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b440b0df836cb6a6cec3c8b94b0bc49ee23beb0878d9c51a094560e496a5ba48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2b9b16d21f9921afaf1614cadf1efbcbad41168278030b245de120b534228d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0176e811ecffdbcf283722f8019b8c3f18569c73409ff3ae1a1b8eee8171a2d4"
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