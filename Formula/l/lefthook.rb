class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.12.tar.gz"
  sha256 "f7e8ff85a08b350e918f176d535d241fd60747c00670a29a3eb80310407397f8"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b961b7f953ded22e4ecef208b9df4cb68d32abdad836a722b06589435fa2a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e4a4496c49a0ad1dbcefd9a1dd636ee0fb8f0d059b622193a61a2e4aee446e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6978fe63c12b23fe4426465453c4f85fe5fc2dbcc7b59cd80c6374e93ea2077"
    sha256 cellar: :any_skip_relocation, sonoma:         "13a537b9ff11cdd6339c05d7a3346a92b5718f5352c509c7f970c2845bd1a03b"
    sha256 cellar: :any_skip_relocation, ventura:        "33f602cecf221b38f0b837c650eabce321837dd616d85db41da594d2af2c3110"
    sha256 cellar: :any_skip_relocation, monterey:       "0e03c09fed6bdef8cc114458867077227f0141760f33d51494e2e368c23ce3c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8109e8de1b9c2151509722565f80961afbf79dadd182c503ea785b2c633ea587"
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