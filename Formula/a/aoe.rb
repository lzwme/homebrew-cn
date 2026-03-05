class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "7a1e708837d64dd0c36e154b4962c9a99de753ce04f07a2007bb7af588fa8d9c"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dde7bfbbb0af26139a8872d982897c83a155347ab9b463fb92a9c3e52c1ad716"
    sha256 cellar: :any,                 arm64_sequoia: "2f706084104b679036fca994d6664babaa822aa754b5307031fdcfbcd966a0ed"
    sha256 cellar: :any,                 arm64_sonoma:  "eb340535c51912afae2bb6d367418f13275c8f6c4706131306816280380568a4"
    sha256 cellar: :any,                 sonoma:        "a6497afc19aa9eaaafd6307c4116506679938e09315c82b442e73d3ce9e08a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955544b5aa25125a1442d87de6f4ec04b6334574525832223523e3512c4d1deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3f32c085744b7a0546408f4af24a000b24186484431e5526e6b73fa03e67b3a"
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