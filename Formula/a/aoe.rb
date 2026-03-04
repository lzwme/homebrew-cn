class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "53c18b4faead3c9511d9b43b0c4dee6386b3078e4b89570fe3f8358fdb576d29"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "005d470d6888e976ee0fcfb0f447d1c24db4f0f68b7b79bcdcc03cd0e13db8ef"
    sha256 cellar: :any,                 arm64_sequoia: "90ceedbb4c9002af222bd379df90513cd6f1c0a29dc862b1fd7d60caafcf25de"
    sha256 cellar: :any,                 arm64_sonoma:  "54a4c84dabb75387d63289acc1a58fe08c65ddad4b9bf7844da35b23c061463b"
    sha256 cellar: :any,                 sonoma:        "89379b277f8382b5d831376f1bc5efe2305505a70e68a0d20f99f1f4670315db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a05e720525f6765fbabf8b3cd5bdeb99eb9daa4410c0b14a90bbfeaee7b377f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b57c99aca6fa24c96545dbf04b6f7fad42b22f68d4503eaf6b144ee6886cf1be"
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