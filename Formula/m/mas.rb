class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v3.0.0",
      revision: "e8993b7de5256074f2fd069d80e60fbc9e4dfaad"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cd574ef2fa8fcbd57d51208b7b78c1dce49bee72d7a94c2b6c38eb8ee185301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81091c673925397daa82d39e78a7fecce014ce8942ece4a3804d0458f9a6dbc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9968a96c48d37995da35a2e357563edb333b856774e0d1d69f3a9da30d0fac1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7edfb5bcdf496b08a8d3fe5e9443c51c43930e437292896e34f1050a9bb57ad"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

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