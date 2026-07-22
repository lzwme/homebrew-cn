class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.137.0.crate"
  sha256 "bcb2d42fd79272fea1bae200dd736ac392dc9d6c9efc97e3dda73b2fc3eb7a3d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28c3353537d4701aa680fb20f4b84709f310e218c45d844793441d956e17d345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3abdb1933dd3bdf338a3efa03e769773f4f8c38ef36fcb9c4550fa4c5f0a173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94c09d05fa2741260bfc1e4daa03bc8e703c54fbaefd54a6e65cdd6535459694"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ab38e3745367171d75fa4bf7eb6378f3c5783ee3e1487236f6d813e523f971b"
    sha256 cellar: :any,                 arm64_linux:   "eb4359645d7db5bb6f6ece8296dc4cc9dbd3abd0d01ce851bc1ade4fbeeabc68"
    sha256 cellar: :any,                 x86_64_linux:  "c36fe1eb8606ebb29c8ba5ea15477ed07f7ee7960438702d0e4d3a3a5416fc27"
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