class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v4.1.0",
      revision: "4fa8f4c1f5f2ae7e9a554451621d054bba0c7057"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12304836d631b809d92158bbd29619dbd3f7343da190e4e086481fd8b7c59182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db78583f34bebbaf021176e05715ab62c5dd3d96751fe3076f3d60d4cb7b04eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8cbb5cf3f53fac08e59ecefa60a4859d520a9a289f53f2faae26edcb9eda611"
    sha256 cellar: :any_skip_relocation, sonoma:        "c267f3e0476ba3bdb4fdd21e266c876b607037c2be4a1d52eb5facbeaca78a9b"
  end

  depends_on xcode: ["16.0", :build]
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