class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.136.0.tar.gz"
  sha256 "0c488f10b53d20930e2132089caa3727283bf3c2b07a2d3211e94fe553168339"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b884f20dbe22c3e2fa478f8053893bc9fd02d05d5e5fb25c8e52c19fea1aa3fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272d5b5dbce317e742845f52f19656faca61b52e7520c77c94dcfd7da1653a55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd5da46c90bf6822314c98a3069335c3fec9778ec472d8f88ed6e5a9eb6722ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "2646c5550a3f1cb12bf1e06596ae1e93570fb64385abcb3a722e976cda13a09b"
    sha256 cellar: :any_skip_relocation, ventura:       "3ddc704d2151ef03f122f64b9302400b05635dfba437f720d2a0551fbbf6e738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96118aec220fab613aeb0ad098509d9fc18023bba47a0a94df989dd725c9ccdc"
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