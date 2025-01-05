class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https:github.commas-climas"
  url "https:github.commas-climas.git",
      tag:      "v1.9.0",
      revision: "a5a928a2e6a28a5c751bca7f63f26b06cede8197"
  license "MIT"
  head "https:github.commas-climas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c42193085126b4fb2b7cf12db3dc4e128e801a6bd51d7e6ff5fa08cf7bccd5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc915a5c1f1c4183306991ac04c7c5a020501f77c33d6e6ac0422ab83dbb5d53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81fcb5149110626ae1c4c17cf2667bb8242b222f1672fdf407b5024e889e0259"
    sha256 cellar: :any_skip_relocation, sonoma:        "212dd3f4603d6459943d141cc979fcb6dd5b49a3f9a09a195de240c4b5c9fd83"
    sha256 cellar: :any_skip_relocation, ventura:       "40e8e55cbe67c93baff9c3013136d6ddb90ac868a9f31f034f808f74d75ba92a"
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