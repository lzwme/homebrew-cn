class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.121.2",
      revision: "6d5b44305eaa9d0a157946492a6f319da38de154"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee43959b7b7ca429fb2d80f994e5b9043790ffa1a197aa9a52df15576978e47b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd86404f726ff1287e85d1a0650aab3278a60e87778adfb068164979cd9cc6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a6eefd9031ea21292ee898a1d5977e9ef9854c0f86a33470a972b496c14422f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fdfad0005c7d95ab7d60828e12121553f7f967d18590e5fe83c5ebec04ae8f9"
    sha256 cellar: :any_skip_relocation, ventura:        "23b53bed02ef5f821662b955685677e4dbc558c43536b9dba0ef812c57065b68"
    sha256 cellar: :any_skip_relocation, monterey:       "be0a00fece81c11eb27d5e3804f93676d4d59649f2734aa3e3dc33a6e45058c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec966437d56e4176ca9476e4352d8e46ab76c11bc6ffc4e1c9b531e818a0685b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{Utils.git_head}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_predicate site"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end