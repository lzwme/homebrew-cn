class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https:github.commas-climas"
  url "https:github.commas-climas.git",
      tag:      "v1.8.7",
      revision: "4405807010987802c0967bbf349c08808062b824"
  license "MIT"
  head "https:github.commas-climas.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d60116e4940c47bd25bc0f6a1892b0208614aa9aed42dcadaa09e3076d0c8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a8e74596411c07d2ed9836cee135d332275c0c16eb13bd913af7a57e26b6a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41063e066322ddf890781b9e52aeba17531d0049f3a7b1a8b2224f526353bf5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c1cf3ef5f895e07f8890f74ee79ab722398dd64a62393bcc74342c52ccc1743"
    sha256 cellar: :any_skip_relocation, ventura:       "753b67a87bdce69ead4ec7d667a3834bb72e9654594e3789f315e70d3f439243"
  end

  depends_on xcode: ["14.2", :build]
  depends_on :macos

  def install
    system "scriptbuild"
    bin.install ".buildreleasemas"

    bash_completion.install "contribcompletionmas-completion.bash" => "mas"
    fish_completion.install "contribcompletionmas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}mas version").chomp
    assert_includes shell_output("#{bin}mas info 497799835"), "Xcode"
  end
end