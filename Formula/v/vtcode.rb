class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.145.0.crate"
  sha256 "503982fcb9caa3b8646686d1598b9ce5724e5b4e2b025d4c8006cb36b37c00a6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6656e0330a89c08baf8cfa6cd1d5d9df0c3bb4c927b30ceea819b264d5f7a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd0c031015d02ccf0a2696c1d4eb6440c8970c3d45ca372edfc57d00d407007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c54f836236da0060531c7ff766e51eb46b522dd85c8a4f1829ee35e48c015234"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1babfda004bd7438fbb31807fd5a39cd9ccaddb0897205873a42457dcb2ddb9"
    sha256 cellar: :any,                 arm64_linux:   "35bb69347e6880fb0a459bf9f03da737331fb42fd0db583266f481eab10ae35e"
    sha256 cellar: :any,                 x86_64_linux:  "7ffc7b45f8f33525f8d4d77a9de42b97e7e8b41274177729a4055f97c2bf951d"
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