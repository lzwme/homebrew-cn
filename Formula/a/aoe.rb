class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "fc059440c76bfe8c811d374a8111d0d8b23031523832ed5a8cec20f479489fe4"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de7fee7199665cf82d309529c2bf7e70df51c3ee3e9f649153f8eeb200e0e17e"
    sha256 cellar: :any,                 arm64_sequoia: "9af672ff07bff04aaf9affb419732ff9204cc99e873656bd9c7931d876887b26"
    sha256 cellar: :any,                 arm64_sonoma:  "4b98f7731f86d1c523e1268ecf4e2a07db7e0c6ddcd634b9d8828699c2ea773a"
    sha256 cellar: :any,                 sonoma:        "d7fc1b30c152c52568de7122414dff1b3e36ef2ff12624bb8665bdb4ee2bba74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ba318699b8ed5afbd09d4e2aee27c5b0b9c37b6914b964e97b95384114815d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e141c861cca9952234d56158b2429ce1c0ad857526213b6932cb4fde5804f7f2"
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