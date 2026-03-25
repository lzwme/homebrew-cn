class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://ghfast.top/https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.7.tar.gz"
  sha256 "d0bf2b9c5563165565db7941c7806f58c1c54f8bcb5f8d1430b0d35f1da7678d"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4698a9f0904339f4ce4e82b5dbb5fc02ac98d5aabbdbe46b373b80263c3c574f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "699763b55e53ec5256ffc1f4bf850ae07fa221d5354659f4e3dd3d0297d57525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2a533ad0159e89adef97111d7acf5ffaf69d12ee15f4ee8ecf647f00def2e22"
    sha256 cellar: :any_skip_relocation, sonoma:        "fced24c0cda62a41f2b711b5230bb43042a401cfe16192a6adb311b13dc24107"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92111cac3a2d0ae11bd83e7e581c199146e468d57b277f6ec7be99e905ce50eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c356889f388183649e73df39bf254ca64bc8e9719073dc42cb3aa5dac43efdf"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash" => "taskwarrior-tui"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end