class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.9.tar.gz"
  sha256 "34080ed47be2328b5e97c6e84232c69170792505d84293c603c75f2b93ba40f0"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c656049f140f86e6aa76d9c4d91b0a7d31c47deefb05084f21e4f78fbbf09b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4791d280a58ca485d1d9804c52f649fb1826f05732dfd5403654a333bf1d4b0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28198c036a49d587360b940d2a8fbf3b953990c4dcba3db3b44e6ab2630451a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2c36a55c2dfd7119efc98e1429d07dc7520692eaf3e12c932033a3a050e8364"
    sha256 cellar: :any_skip_relocation, ventura:        "c4049b4709400193d8f5d9d6c52658491db4bd885c27b3da0d4e1ace19e165b2"
    sha256 cellar: :any_skip_relocation, monterey:       "4920d1989fd39bdeeb866ef488726b5f60ec7099f0d3b116e586600ce8e69134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e5129a6a72aac202c4eaab16512924ff4bf12ae7ae6ba863c7b90b871a8575"
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