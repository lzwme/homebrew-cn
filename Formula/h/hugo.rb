class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.130.0.tar.gz"
  sha256 "929b6c02c9c50217d57adfed07dfaa3f3ab5ff3450604bb8decee20a1e465424"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f5f3c815c3d16992cf3faf9cc52e418af72b47ec7dcc72ae6aac96617bd2954"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9249327393008129ad8f0597523aace976ff396fa06ce92444c82c64c2f26f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469cf0bf1b5f23f9afbe8a0d1e5832aeaacefc71f744ef445be8cfcf02e2ed25"
    sha256 cellar: :any_skip_relocation, sonoma:         "05d33b005428303597d39fde1a71cf363b21db7f6b6b176d59526e8f0aaf1838"
    sha256 cellar: :any_skip_relocation, ventura:        "30ee59f9fecca9c1ab380aa9f8fc2b111e8bdf56f99d28ca4a9806f94979ab54"
    sha256 cellar: :any_skip_relocation, monterey:       "a8e6c33445323f2aa8bf00f6bf9b6dcf69c701dbe8eb4ac91acc78d77f292052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d0991c46ab216b5b4e75b17b18518bf1fdab07f75e88d20fc267fa3fadd6c00"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

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