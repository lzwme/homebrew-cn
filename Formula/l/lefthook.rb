class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.17.tar.gz"
  sha256 "f47ceb2790a5db511baee7930adf499719682f0103ae63c66a064b3de6a65e26"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afb01661ee2d7ec45a9ed57891f75da1b44f461c0eb73266184cfb05db68b7f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed1825a3687cf8c9579e452bfa047c16e5e282a66645d263a9d33f4abbcfd5a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "800128ce08ad90bbe63fb71ed4e07c9b70e2fe80d9f86d45d43c53909595472c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd5a2ef60598e86ccc9795168b24be1aa93a664ef43027d1ee51fc4d025ae837"
    sha256 cellar: :any_skip_relocation, ventura:        "71226caddb590668186d91bb82db9ae20ec45c0e48ab9c61e924e26048dfb972"
    sha256 cellar: :any_skip_relocation, monterey:       "bc95dfa714426f7fbd719c3f912d7c43694602be9cc47ccdb580eae13cc693b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1001a32819b037c43b9607aabf086e2f73479c7cf02b085966d161d2e585e944"
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