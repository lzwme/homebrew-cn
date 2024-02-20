class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.123.0",
      revision: "3c8a4713908e48e6523f058ca126710397aa4ed5"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b5311b3c8d46bf9dcfa134d7925187fde7b70e0a8a9c639d82fdf112b6b4191"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b72b455ef75bb7acdf2e884bc4202e1a6451b479c941fd0c3cae5b4529b9b8eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c997e9d1db04e48e9cc15daecf1754e308ed621bc8979c75d0baf404692c9e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "34deceac0ab3a95cbd72e66ee648f81211b834f31cd93935a1826b9687876db6"
    sha256 cellar: :any_skip_relocation, ventura:        "11aa0ad61de25baa1090d2ea6d8619b8855e62baf972374c89488a17983a3d40"
    sha256 cellar: :any_skip_relocation, monterey:       "6aa89c3a010afae594cce88ad0f081d5cd73389e6d198dedc1c86cc22a439351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83addf55e3c740bf1984726c4b5965b28a63c2c15429b3f38163797645362ece"
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