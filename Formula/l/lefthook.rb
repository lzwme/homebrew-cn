class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.13.tar.gz"
  sha256 "94324d9716ebc846030a4445e8d0895834db7e152f96a1da8b3545a8704ff1e5"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3575d1fd6c3ee1496a8046ecd40a967ee982f46955f3499051b1b18748e520d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a6aeb622cf65fbb463fb6f70b4ae247bee90d76bac95b8a6a6c130c2fc702f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d128627ea74a6a5795121b19e0cf7663a5ff3bc901be0ebb2c28ab78f2171165"
    sha256 cellar: :any_skip_relocation, sonoma:         "e87e81571719a6111d1ba8de2ddd320a015c167a2fca2cf3a9e10de6ffd736e0"
    sha256 cellar: :any_skip_relocation, ventura:        "195c4d2dd697885cb1aadb44e583c15656d57c2e163a7afe7f21a6ae25b6de92"
    sha256 cellar: :any_skip_relocation, monterey:       "bda8c287c3eceb7cda995d425a0c54a00831725c1c53f33620749c87a220c916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "490ff3f9218680fdc2ca6235a6c0f36ac382c693bf2208b6826d0d5289079e0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end