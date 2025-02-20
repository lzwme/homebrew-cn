class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.144.2.tar.gz"
  sha256 "f49a3a6148ee3f4a7bdc331ec6fe2bb106c5e54268dc5b8d3f00fbffc99d6f5d"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d7db3dda45d11ba6a519ae39a0702f6215d12c866ce97bb1f057bd0ccbbc8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ecd0adbe2850817fdfe3369240f3b21f43a5d97d2955574ed7ca848baa49641"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8449cb8e96cfe46105754a5c62131d8f3de2a0d0ad93974d6118cc2c40bfcc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bb2ecf868dd2faa9c13f376c2d17c7e5d904fbbbc5bbdf42305f75189f78f2a"
    sha256 cellar: :any_skip_relocation, ventura:       "c29872b475111c622467b39c704715f8822106aca5c23cb7f3475764fd45a4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca4fd36b35124eea62529e2576460591e9606eea84b1552107f452dc727ca07a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_path_exists site"hugo.toml"

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end