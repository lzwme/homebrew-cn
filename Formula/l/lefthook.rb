class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.2.tar.gz"
  sha256 "85f3eef7d9faf7a82d1f67585756397ce9c83b15cfd5a344dc1efa0cb309da7c"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1bdc98ee67b0ea77c4d40d25519851e609240dd077f09a70971b3f59edd617f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11cd650431926906c41953dea16269d3fa8c68ad7c32d09ce23ff1e858066b1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f3fe18f95b3b92ff2b30abb3837d47216b7bae13326cbc888e20d9b8cbe323"
    sha256 cellar: :any_skip_relocation, sonoma:         "49a5cebb03262d6621cbb6c2ea9db1c39f43e39facae01947e69fab1eff53acf"
    sha256 cellar: :any_skip_relocation, ventura:        "b0d6c080b230ebfecc53cffe79491ee93b946b4d9521ada7ff8f5ec5a3e8241c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ac06990dcce8bc1db5bc3a8c31d592c23c83b7383937a6a1c72806b5ec4009b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9468781a77c5c30636d5e9e954f56ac34b07a62c65c1d021f5f0fe45becb2ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end