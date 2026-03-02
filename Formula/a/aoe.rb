class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "6931018c8508a9d37de8a6bdbb40e0816c25adc8cd882838d1468b09aa505e38"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d07caa31af5a505382ecffe29c4047244daff1383563821ce46a21f9e69152c"
    sha256 cellar: :any,                 arm64_sequoia: "58c68cedf4847aacf9a55b80847fcc45d8a9c78c45ff0248a4a19211a1024e9e"
    sha256 cellar: :any,                 arm64_sonoma:  "95cb8fc11a2387ec77d4263635eed4958b5568db38c535d38850760247de1670"
    sha256 cellar: :any,                 sonoma:        "8f5a069ceeeb58448547f686f3efaee5df63bb2e8eb79f2cd863387e1e6c1abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae55cd9da16a6fe291c6ab5964f5b81badc3ac930c860632c0a4363cfe8d3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb477709a6b6b38a97094fffac54a9827401c4f9e596106ab85422a807a153bf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"aoe", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".aoe/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end