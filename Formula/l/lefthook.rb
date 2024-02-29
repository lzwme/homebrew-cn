class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.4.tar.gz"
  sha256 "5fbd046e2ac1c6b9b2a966ad6d174827f36e0f1dd82a20b609cb8c23a0d81632"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9185dc6f29cf8a40d0ba426f9123099a23e8042c8ba98aae77570594f64e9236"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bd9fdc3027d13146753ed16c1d680472a70b64ca8e88df45bd010ff7c17e4e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bce86c60333e5590302f20f6f01b5cedbae2cc7ec444a4165023502ba0fbf38"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0f683beb6113971e6e81b8b94ba845a5cabc4ca8d675c707b617720afb293a2"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f78385eb7bd60e9f4f0af9a175386e1211047b655e66724cf3a77fab2d4c06"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d1701d1b542cd6c5cfbbdc6f30c689fe17aa79640cbb7cd298045dc75ff57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0589973bd90f37d0d6543405fd2fcf647acc2a1cb2b9fca37de0004b1c4d5622"
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