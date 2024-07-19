class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.3.tar.gz"
  sha256 "6873d84432d329ada95b6c775beafdb4e314c31e5988d56d46ab5ff388df7f45"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b5e0b2c7fa46b40023ce6ac7d7b2a6339567cfefe65abcbd85e286478780b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77d49c7f68715976c2d4b757d49083654cba93f9bcb03c0b5d40b9de04687461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88075e71e248134a907f33c6b9ba08fad83d164b5a697e0638330ffd73eea7a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f9ea2dec55ea32a608d3ccd81d3ba5fcd83d6fcf7a9dfd1ff291d98649fbe5c"
    sha256 cellar: :any_skip_relocation, ventura:        "b81ccafe5eed8090ee8878f06280d9311311e7bed63ba461d1f9fb2fb66e40db"
    sha256 cellar: :any_skip_relocation, monterey:       "63633bb714704210a550c09a2cde599c4342d2930863da3c3985893b50b7c54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0186534b38c4b9ba4434bb7fac6704c23757d2a5f5a81c841b7838052fc26e79"
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