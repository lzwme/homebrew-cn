class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.126.2.tar.gz"
  sha256 "1ee1a7948303937e6f846bdbb99fc3681d25418d25772edb7a367b3456ef05db"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7de901470d9c521897fe8825de7ee7c1ba5db075af1781db7628746cdbc2750"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28cba014669a9573c55fc477cb53cfaead24d56bd6f2c449d238c4a464f1bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab16dc8c0f938523267663925ae17dd047c2933657ec89c5211796ad9df725c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c703d3812434155db7fe71ac3eff1054ff5df9a4e3b9f0ab0ccd5ab10b620f6e"
    sha256 cellar: :any_skip_relocation, ventura:        "38880266cddc201ca141e9bbffcd9090b67f4f6f8c0705ad18ce92213c900a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "00edb72713129855198bb574821d2e0b009e62a2123b668675f3cd87adc81bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689b229327c2d211d4cebd3b3a5d61b33de696d35e71c3eb4fed9af3d0e8c064"
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