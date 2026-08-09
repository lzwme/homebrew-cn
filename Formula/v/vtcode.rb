class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.142.0.crate"
  sha256 "7b934332503f74543f8731ce222b782b00901499797ccaf87525af27ece94619"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42b03fa9657699f3e478954954ac873e06d08da5fd0cff793abc5fcc13f26999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b78ac0d1dd1ec2538eaa8b790758b8b428ece98ee1b75963176634eed11d854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70fc89f1de1cfb94e18a0b4e943a91d887c0c92e4036d8aaf786446bb65509c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "946fe58077f10ee57f383061741b677b8b09f5a06bb303116369e2071b82be49"
    sha256 cellar: :any,                 arm64_linux:   "bd174e73449427c8f3a58c9994d1db31f11b6b645d67231d5b7ccc1bbb54b070"
    sha256 cellar: :any,                 x86_64_linux:  "07785a838d17843083ef2fede9030d3aa950fe25831809fedd92f6f79daf8772"
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