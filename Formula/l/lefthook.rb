class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.11.tar.gz"
  sha256 "37afbfc4fdd2350afdbc8dd7bbf2e673ce5e46070b97bda0bceb2f8aa624f893"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa4c47c518a74a6ebc52c71e1e451e0f924e560a6838335b7ab7e8d232c702b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f453c80eb2ef47c623b26db0c03b53bb8487e0a1cfe2fd359016d37e01a55b45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f05b595f90ffd966991ed7fd0a36ead3ea144986920c3d82c4cd58c125ebbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3299515f26c8de3a14005b8145bbcfa09e67d2771be509f8d95f253db9008c49"
    sha256 cellar: :any_skip_relocation, ventura:        "c6e2020c7da153b876316ba4c6423840588dd1cef6dd3c7b41797f84ecb9b8f1"
    sha256 cellar: :any_skip_relocation, monterey:       "af95e9ab23b79a74350b3ab47b9d8671a10b159900d5ea12c75856f4ad3f6a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80064ae010d4aa89e7f47bc3a7fdbffc67da8526ff6434d3a1f093115b5fd7f8"
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