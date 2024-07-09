class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.1.tar.gz"
  sha256 "005174f8c31ecf652d3be2e161ef41d7bca13f1a1cada30a9f25213857e11fde"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a83a27be5610447a43149ecd8996aa125534649079569fbad45a2894a7992d76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d33d5812070211419bc4ffd4d5b4dbff64604dc4f81d5959c38e43a6772ced12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0597c1168a2197b18f35d77c1571210a39a6b74e69377550cbdacd06cd1403cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9584480f3f1384b15ab9299cf6427951b4da9eaaa7fa7cd22439cc0936f62d22"
    sha256 cellar: :any_skip_relocation, ventura:        "1ab2400a68e1cffd8ee49c4c3a00198f5ada01be10b5ec7cbf832e9fef7c8fa7"
    sha256 cellar: :any_skip_relocation, monterey:       "b6a60aaec6c2cd39fb2c297adf9cecce7173f15c02574647466de286dd943340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faf3b3bd8b719d1819b703e0e953a891b7a864c4e857883bd71f6e065f377d26"
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