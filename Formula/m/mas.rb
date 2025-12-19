class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v4.1.1",
      revision: "dac9fc222fe4c9a3a14a073f8ecbf93279568a74"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a79e8bd2aa42699320c13ebea5c0a6f36c602b674fb38793a55632afbd24e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4aad2d8c74d92478bf7d6f7c1f1558d537c334218646619c137f8dddef90ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57663979cfa593ece69f62bd84a21ce2eec4ef3dec245f22f2c7dd25259c2e74"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3717751838c37114159c0f111787d86451b637b0a4a4f02d9dfc89b84773cf5"
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