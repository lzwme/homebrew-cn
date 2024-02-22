class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.123.1",
      revision: "3f8434a62fc91a50f4e5bd43a4435d2d301844ff"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ab0588545f65875991cf633da05221b34ad73aeafff1f5bacb4450c428075b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b7beb873be6cec998b72134647ae56beed2933fee04a2506b0492aa81e23691"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb5b16a0bad37c8914e9e0d5ca92bbef1be56e4c6161819e7ae8fb26dc1ccf81"
    sha256 cellar: :any_skip_relocation, sonoma:         "301a61e896c8c18b69bfcd7aff74e1abb34a8e089210b7e14c0a17460d99502f"
    sha256 cellar: :any_skip_relocation, ventura:        "b2963494fba6f36657f045482e93d6dbbe639b6685c6d68be532ae198873557f"
    sha256 cellar: :any_skip_relocation, monterey:       "ecff3e520234f4ebfc47fa7968567cf0edf6dc4d7c2a18982f4beaf905754568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fb8be3f97523e7edba79ea2bdcec8535ab3ded285bc9a37f17f922830672fd"
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