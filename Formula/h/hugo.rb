class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.147.9.tar.gz"
  sha256 "66c05149b3d3e2979d440fc937b78df85246823aa1f15053d88b42fa514291a1"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b27b76bdc7c79fe4e6faff1f1afb3e88cd802ac8fe74cb03b99b4a124deda41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc0199a51f441f83c5a0380cce7183249c84a4a3caa72407560891cfcbe70898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbb5a324425551d94b4590df2c651b4886f4a5db5bdec3005022022b0cbb6de7"
    sha256 cellar: :any_skip_relocation, sonoma:        "38654db7d77930d7bef8433533a445967825007e65172e260cccb4eef85bfcb7"
    sha256 cellar: :any_skip_relocation, ventura:       "12d42c7f7ee796406be01b31b30ce6fe646fa4283fdea1b46a653135174d194a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ef2d283c000cb5118598b43d108708ba0a446916b7e6b13298da247cc17c32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f51b7d37bffde03efb3d30406635b5ffb259c8b55139cbf276fdd5730f05538"
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