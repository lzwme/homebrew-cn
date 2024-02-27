class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.123.4",
      revision: "21a41003c4633b142ac565c52da22924dc30637a"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3fce8ad9db4c2314583454aeabd4653eb6403b6db788a294724b9b63508606f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "991220c554d14d7c1db2025a9f84f9aaf0d2ab81ed811cc09a8e685412310d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485c51e356945ec7d812da091c28ba8f6a3b5b7f6d1f77285268d95bf37212d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2405c71b93db7beee18e89fd92cac7232873f89ee4b2073b13d5a7946baf71d0"
    sha256 cellar: :any_skip_relocation, ventura:        "eac2d51f8ed59bdc49c93b18b8ab3d1f4dc01285ff19efbd24064f1f1d2829b4"
    sha256 cellar: :any_skip_relocation, monterey:       "2797bb617fe3ce9e97f2251ea85438200fc2c697b062e084d2db3cd2445e4d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb2bd442d512a793b2d886017587a24e3754ac14072449301939219d658ba0ad"
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