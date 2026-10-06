class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://ghfast.top/https://github.com/sharkdp/hyperfine/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "aee01125074fd5a6a556818db7bba0577edae94cbe85165daae0e778aa28348d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49d68347bfebd41af0a652dbd4714cda818c8bde1b9996c3f15f5ab208c376f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3663591c6a59dfefe6d68638fc61d022e78cbee65212472bbf6eee3ba3b053f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b46aaeb2d33a2148246b8bdf4df5a7e7200cb8d4e2c5aeba93bb0c147b19062"
    sha256 cellar: :any,                 arm64_linux:       "cbb753bc1e355d3d50de8d47c30ce63ebf8dfd1bd26f296f77032bec3a4461cd"
    sha256 cellar: :any,                 x86_64_linux:      "60c45f07fe5bbc674704b386d269dfc765261f3968f5aa7c57c2f45684236801"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "hyperfine.bash" => "hyperfine"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
    man1.install "doc/hyperfine.1"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end