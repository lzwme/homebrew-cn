class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "3a6777f0d8bacf938cf9df84fff4480df800339e9835cfeb4c383562fdad5c62"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cc56d1af8b248c5bf2f49a0f6e283615b92c027198aec45106f06316b3de4f7"
    sha256 cellar: :any,                 arm64_sequoia: "dd9b1daccf0d37772ec46462c551ce55593bf1ee837421da6b5a9fec2b6c987e"
    sha256 cellar: :any,                 arm64_sonoma:  "af46cd568badba7fbbbf005aefabaa8e2c720af812ed9969b44f1c9fc03ea174"
    sha256 cellar: :any,                 sonoma:        "3181ad713ace63babdec7d566d50b4534b148d1c4960d379ef7defadc4b7909e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5944eb50bd98a169746664a2a289c0e2560793f7e98e1d56c41f28a3bdc702e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eb7d7d36fc287abf545bfc22431730e0e5dc27fcc7ea6f3fd7a1f6297a6a204"
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