class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.147.6.tar.gz"
  sha256 "481f4b5a902529c33bdfc047e1a9d4df4daf7e26f90740568a835f0843692def"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50bb35f6c3e4d3ce436b4341ae46fc1d8b3d943b680f63524e7d866445a226bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c213914ee231f9bec84bbab12da30178ded000df7c0dc181cb6e4a56f49534"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a9e52673f9075d4cac881526d7d965f3ca013772a20e8ebcb3a4c30fcfb5a0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8d190bf4918b86a08cf747b63b45b11acc050d26c4cd1eab65efe4d530e3a57"
    sha256 cellar: :any_skip_relocation, ventura:       "a8b2e2cb9974cef3eb8e165b4764d44eb337f761230ce94d6515ca5c43920076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f57f5674be6de64a536b70216261311e5d1e072bddd928d7539057c0fe44be0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4611fb0275c8235191be9a71e3cde9d044c0fd89c5939fff817b3a51a9831180"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

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