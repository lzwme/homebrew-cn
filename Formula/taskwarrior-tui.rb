class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://ghproxy.com/https://github.com/kdheepak/taskwarrior-tui/archive/v0.24.0.tar.gz"
  sha256 "efe445908b18c52ffd1470a3819612926b961dfd84e0fad7cace325f5b267c72"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c830ef6b28481d5d8eaa670c89c6cab00f765cca4f5b86f38396e626052eb43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd9a7167773e3b11b7ec5b9134cc06741537349b0162f04bca7673915b4229d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44d2214ba554c7bb9319c413d5588dc99bee12ceae3748c987dbd697aac6a352"
    sha256 cellar: :any_skip_relocation, ventura:        "a5ebbb12e5cc4e55c0d16b671a8b7c3d7dbdd6a62dd4fd995e9e7692509856ce"
    sha256 cellar: :any_skip_relocation, monterey:       "a3be7eb7596cac19134b775f613c24534045eec92671700cea700057d42f6b53"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b1ad4a53fefe0090f388830b8dc10df08dc8459cae99b3ff5642ac4e9d97034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d14ca64dd60fa82bce990072e56c6acf091f0046be8cdbf727983f4148d86cc0"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end