class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.5.tar.gz"
  sha256 "f4c900f5ae33567a8928ca3bde2106da4254ad8f7a973a4fd785ecf4b7bab58d"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0384184312c0139ec416b0ee651465522f8499bf4dc0456012dd1906bffe9f62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f56387cef802523ed5867dea244b2d12f0e750163de3fec8b9cebd09671aea1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1535046b122eada7ca8b9bf4bb0c62b9088378640396e511ed2837c81e4bbf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb244732f76217694733b17b2d32736fc17a02555a646b09ca0c08e0aaf1bcb2"
    sha256 cellar: :any_skip_relocation, ventura:        "ee965091e39ba7a9d3cd361acf644888cff8552ee668e87e63142cac547a4c77"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc922919d34cbe13e092bf671f1b26fe3de122cac11e40cf604e7a7eb7b732a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed105f1fc21e0fba264749d7964ec0e04a7959c5f926da0b55b45f8a806bbc9"
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