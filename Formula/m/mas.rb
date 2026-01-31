class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v5.1.0",
      revision: "5a53d3d24adc5db2427a6645327f47540ba3de03"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df2815e0868c0e6122a42570df3f956dcf20b784c1f90ac0dd1cff3d258279f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e8e1201420b4fe854babc714f9ab19bb94584f098321b2eeae34c83d4c75de5"
    sha256 cellar: :any,                 arm64_sonoma:  "497da678c52933d929067c43a8557ac91e30e9a64ffe5edb0e6fa7b3c8f89a8c"
    sha256 cellar: :any,                 sonoma:        "4b665d3ecaaa13cfbc5c7775c1e09545b9caf5c0f93316947d8df887b553ab78"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

  on_sequoia :or_newer do
    depends_on xcode: ["26.0", :build]
  end

  on_sonoma :or_older do
    depends_on "swift" => :build
  end

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mas"
    system "swift", "package", "--disable-sandbox", "generate-manual"
    man1.install ".build/plugins/GenerateManual/outputs/mas/mas.1"
    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end