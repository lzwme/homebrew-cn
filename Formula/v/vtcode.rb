class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.159.0.crate"
  sha256 "27bad71ee124cee7ee8484b663528aa9fd24316dfa4f3d846a136060a8aeb85d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34c6769219714d3809b6f72e64f7566b77e60c097fdf8b018bf21c1a25d0553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "413405475811f2a56e80fe1a4258b618f355718e7bc0fd40497a726c0e064949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14eebb74cf0a59d63bfa79f6d3238874d77b1aafd0a7fa6c71c40ed77712cb3"
    sha256 cellar: :any,                 arm64_linux:   "4152acecff1bd07ef829bbbc3b1d317f6e4725d3bb5a7c3ce4d651929435c8d2"
    sha256 cellar: :any,                 x86_64_linux:  "e2c5a99722a74b963b97ca2c131cfab0a86251babe48794bddfc2783cbdac431"
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