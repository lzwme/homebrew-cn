class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https:github.comfalcosecurityfalcoctl"
  url "https:github.comfalcosecurityfalcoctlarchiverefstagsv0.7.0.tar.gz"
  sha256 "3897b4198927ba1b8ad7012013d9b714245ce1a11425afeb94f04e36d0ee3569"
  license "Apache-2.0"
  head "https:github.comfalcosecurityfalcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3229c22e6be55b830e5a2ce1e79cc044a7382c60c2eb117be85809ffdb6b88c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "142638a2d1c9399c1c7135faceaf0f61f2d04da2989ef9b75344c14d7b4ef42c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "136484ae054b8278cd6f8e41d5275a030aabe06d0199d14a3c2a0be075c143d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "92e2390fbcfa9638a722b4f7a10513caaad997203c22a6af56dc7efb01a2356c"
    sha256 cellar: :any_skip_relocation, ventura:        "74e938d484d3f9c221ae9afec4ba4e55869cd54163da2905ca882ad159e6b40e"
    sha256 cellar: :any_skip_relocation, monterey:       "6691d68c5b12ea46851120f0feb1510afa54f9b4b9ef380c526448bb0b0dcfab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "774d9370d3acdce51ad726a83a0f2324d2074cbb59e96501f7ef08f8c2dd0c1b"
  end

  depends_on "go" => :build

  def install
    pkg = "github.comfalcosecurityfalcoctlcmdversion"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "."

    generate_completions_from_executable(bin"falcoctl", "completion")
  end

  test do
    system bin"falcoctl", "tls", "install"
    assert_predicate testpath"ca.crt", :exist?
    assert_predicate testpath"client.crt", :exist?

    assert_match version.to_s, shell_output(bin"falcoctl version")
  end
end