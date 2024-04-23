class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.125.3",
      revision: "474c4c02212cf97712c6fbf4159c68822ea6e078"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2a0603696bb66257cbd6714d8adf9b56faded3707d51912b90c8df4965fea28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "807a2d2766cf7ecadf120c2e78b420059baf7316182e4e9b2f0caba9f23c6418"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d145d8e5d8585181ddf91e78ae012a4626bd9e03142b6d6315f9a9beef88632b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea62b2e65ca077c2a0698795aa8a17040fdc4d1fcf45858263e3b9c1f6154fe9"
    sha256 cellar: :any_skip_relocation, ventura:        "8340ffa4350254db72f5af2d657e20e99393e300a95bc4552bae6b38b56a6d38"
    sha256 cellar: :any_skip_relocation, monterey:       "aaa0ee31a978d1b12854fe07fa13acedaa3637aec2ec04073c67fa8dd71839ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca6a941d5a05a8a8029c60bf20abe0b29612d1e062ffbd03ba9ace9c835513f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{Utils.git_head}
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