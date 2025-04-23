class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.146.7.tar.gz"
  sha256 "5dd03cf8008c9589fb5acf74628065b365b75d144ff76ece9bc4fde80a304b0e"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d35bbd94a705f661a4e9b234bc2b284c2f1e609aa85603b33316b1804e2ceaf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe744c0251f85cdcf8073a13be4a3ede357d05e81c8d475ccc28cb85c3bc7152"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e990654bc763527c9f6197d10ee49ac4e90c0a91aa963342a8034e39dbbd7fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd72093ef3bf384a4d0fb74dc7f362259029f61cc17adc0d673f9aac02c2a785"
    sha256 cellar: :any_skip_relocation, ventura:       "5d15c16c2641bb91ab36d66228b9a285ee5d3dd6a648ee8a9ab03697c481ad1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d784327a6339c0711c628f830340eea024487d492447837ab8940a48fe1a90b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d43a0b09a938384a9d58a985133da8c2ad45e89c916e2528487b862c3e5206d"
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