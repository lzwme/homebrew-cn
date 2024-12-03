class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.8.5.tar.gz"
  sha256 "97a9a2cf9c4ac0e9bbac63fb8c67564ccd8d0ba3bdfad9538d513678619864a7"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf99f9d5a58d03cb9612f765228d36b05eb1f99bc4ac9fa4c153ac0bd439042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf99f9d5a58d03cb9612f765228d36b05eb1f99bc4ac9fa4c153ac0bd439042"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecf99f9d5a58d03cb9612f765228d36b05eb1f99bc4ac9fa4c153ac0bd439042"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e7d91e58bab87d6225899d04744f84c9f0cbd064b3dade52668d6375df29d14"
    sha256 cellar: :any_skip_relocation, ventura:       "8e7d91e58bab87d6225899d04744f84c9f0cbd064b3dade52668d6375df29d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27d02ad7c5696414c80d147a574ed53a7f69b81edc05cbcd03457d8bc4b6ec84"
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