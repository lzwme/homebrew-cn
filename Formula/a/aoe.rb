class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "7fd5f26d1c2aaf567539d4d9aa3fd32e134dacc1a5b13d4c6e5e2403a82d21bc"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61ac208336f339aa88f3f25f10662287379d2c6ac09f41865f9d03fd12a674f8"
    sha256 cellar: :any,                 arm64_sequoia: "38672886ab66708c9b4679dbe7a744ac879aa52165f6161969345728d847a701"
    sha256 cellar: :any,                 arm64_sonoma:  "a710f10c337f8acacceb85d2f85113d820da87e5f6809c73b109efdaeb65649a"
    sha256 cellar: :any,                 sonoma:        "e481702125445acc852e84076af79fea243215754d117f9908be6eb725fd51f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70f644fe8fe625dc50d820beed17240aa5c4501eb3d9bc7bb86c4e390e6a9ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b233609ff63484edadc3e8b2ef29f608f082a245ce3c72e21ce9ea876554ccab"
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