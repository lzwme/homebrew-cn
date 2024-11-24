class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.139.2.tar.gz"
  sha256 "979eb433cdad8e6260505675365e4bc702213f7c43d7b258b4513a7898f2768f"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57c07c6272b5711b7f3cf2fadf8d0b73ce2babd50a9d419e26687122667ddabb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0785d59bbd09092f57dc8fd8a8ed1ed092a48ee80f93298974e3c70a141b0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1acb395c46b8d9ab48b26d350490728568106c8dfff4acf60f1be4a4d0244a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab7f81767d2d198f35b1fef34428adf32598a5fd05df3ec2de59cc3b215c1deb"
    sha256 cellar: :any_skip_relocation, ventura:       "9c355809c2a49548eb8efb8b82cefcb9aae26c787b024a6b2a29cfd2263c976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "111664d083e51cad4b3ce4a9522d5f40139997de0d9c27652998d8a506dd3cf4"
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
    assert_predicate site"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end