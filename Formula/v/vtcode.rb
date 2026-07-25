class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.140.0.crate"
  sha256 "cc1c94c21924325af7cf13ddac00bf95ae71ec95f9abf6034a60d87389b1d848"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "609719fe188e135231278cf1a14e371d7e5f65e07a9e887d0b17902ced14df86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86082e774b417dc9e301bf0c3cbe7e5eda9cdd3f0c4fe9ebb397d1b704a4ec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74bcedeb49c3cc04dcb3179388b7fde271911ad52a2814e3a47372a4ff2b8558"
    sha256 cellar: :any_skip_relocation, sonoma:        "155cc9f5fc34441f334ee5790ffb891ba6782a5d119b9c72c70b91c4f1a74f62"
    sha256 cellar: :any,                 arm64_linux:   "f541f45833b0bdb0735fa06c100015b20573297f8b4baa69be0b8767e2f13d71"
    sha256 cellar: :any,                 x86_64_linux:  "40f16bf8fe410af077ea80f703f4321bfbb67752be564d73fd81bfb67b6beea6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
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