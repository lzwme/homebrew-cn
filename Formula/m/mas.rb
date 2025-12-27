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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb2b42291e08e1f9bb8a016d0faff3128a61eb8c9326f88431c7812ade7984b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95511575a0d72b1e293b0e42aa9e46fe4e8c981ff0c5947eea2672eeb33af404"
    sha256 cellar: :any,                 arm64_sonoma:  "a7fdaf0c2fb15169b75763fd54d487e851492b4af107e98be1d601cc06ed35d2"
    sha256 cellar: :any,                 sonoma:        "30634436516c93ac57cc8e9c7ad32ea3bc179f80b6cdab4aeca3a57317ae1b74"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

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