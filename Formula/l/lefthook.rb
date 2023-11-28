class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "619088326c7aa82df2deeb3251bc150f7b41625b63d53d5212822271987e4c1f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db8e4af3d8b95058d0ae55abae2f0b0f7d31c77e015ad9ef031f98b80c951a50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eca19dd54b1f644faaeef4a1b6aff90966ee2fc6b50a545f243ce34a68f4d5b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9a8763c9978f0d6b5f79f7bbfbe94b2e7df042ae4880916605d0a30832c6de1"
    sha256 cellar: :any_skip_relocation, sonoma:         "269c782c666c87784dd780d51110f51cc5759c66f4c3c912e28ea6f28e79b15c"
    sha256 cellar: :any_skip_relocation, ventura:        "eed307531882930c575ea4f35d035b4ef620f2281465f2132fbf55c67e69fb99"
    sha256 cellar: :any_skip_relocation, monterey:       "e64d1f0551dad955698f8d4f9b37b4c51df722b435934fdb4792251025946e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c04e178f082e77d63063fec08747f5fa094f5ec8bcd7a94e0ad7a626f95e8f98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end