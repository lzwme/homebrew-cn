class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.147.4.tar.gz"
  sha256 "aee3fd8903dce762489343d07108eec30a93ac7479cef1322d59f071b531ccee"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c703f0becabc1d2f787e552454597962e063011dd3bda268d8cc3e7227ce1167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4efcf608c64ef750a1021ea1789e335c828f61bb2d37561c0e2c24562f3ec0fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bec2aa039cb21ef3e811179ba0fa76ba0b09a09c602bbfca0662c9f75839f371"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d23a786ded9eeca41eac8b79d5e38e8c942df18741d6ed4b97ae9e971c838eb"
    sha256 cellar: :any_skip_relocation, ventura:       "d0ec067d5f0ea7fde92c230a71f7edcd679a86d7ddfaaeaa79daf685151aae73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a370095755a9ef44f48cdd9f33598e710b65b6181e6468f6939d31867bf4124a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb1c3ffe6586d47f9f3d4caabc60057cd0fe4a83c8ceb98ea59d55d95b1d22e"
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