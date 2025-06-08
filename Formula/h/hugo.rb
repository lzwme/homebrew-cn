class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.147.8.tar.gz"
  sha256 "b2cf9f0b342bcdecab7f038e451072aa58bd1352c200bc32fcc9a5ce342fa2ff"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa376ddf3fea3e7435ff9c685ec63a27081271d1f0937e87a5f43938198ef77f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a293212cfaa3cac6ae0aef88acb7f71b4640e69165a2eab666d6fd23bfd1faf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56c5f63dca9744bc7bb612845438a3849a289553856107f0156214aff318f559"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d65ee324a13e4b26541b875f89b286763f6555b2ad1b145225e20d0bc10ec9"
    sha256 cellar: :any_skip_relocation, ventura:       "7f30011d7dfbd5fa52b358df11d87b168901b9ca8652eae4d6c3bdfa80d8c85c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1759bce489f9f38652a6a0e5d07cd88bcf297125376fa889720dff77aa3f86e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b31e5aa5c8e314689832676f31eb8ccc6215817358fcf2e9a1b54bbbfe1cc5"
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