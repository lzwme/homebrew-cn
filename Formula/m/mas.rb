class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https:github.commas-climas"
  url "https:github.commas-climas.git",
      tag:      "v2.0.0",
      revision: "5c1cb403cb710b8e81a192331253eccc6fac42a0"
  license "MIT"
  head "https:github.commas-climas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beeb7afa648443d843a545bf151eb4943c0c7f2a1609b8c90f3f9531451300b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2e43ff0b2f02d3862f459d44cfc4c70acfe408eab2329fcedc782dfe52a32cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf4c44c24dd6fd0f628e32302058840ea221946502ec6a37841a9f3236c1750d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f21f1e16243690a82d11b8a9f9790860b4edc57c7aeab2b11513f85e47f8c3e"
    sha256 cellar: :any_skip_relocation, ventura:       "4fe90b9c79334e5b7959c70e8139737e6d00ce0503f4a33490c4e02577f05040"
  end

  depends_on xcode: ["14.2", :build]
  depends_on :macos

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "scriptbuild", "homebrewcoremas", "--disable-sandbox"
    bin.install ".buildreleasemas"

    bash_completion.install "contribcompletionmas-completion.bash" => "mas"
    fish_completion.install "contribcompletionmas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}mas version").chomp
    assert_includes shell_output("#{bin}mas info 497799835"), "Xcode"
  end
end