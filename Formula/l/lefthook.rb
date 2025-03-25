class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.4.tar.gz"
  sha256 "29a66dbc99212715b908095005e58bdb685640feeaa5667c8534c187a1683fa9"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daffe951a9bccccd748aff2eb88abe9205c47971819a36a1171eca5137610f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daffe951a9bccccd748aff2eb88abe9205c47971819a36a1171eca5137610f0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daffe951a9bccccd748aff2eb88abe9205c47971819a36a1171eca5137610f0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "664a13ecb97fa56038730724c6e13e5db145df283ca54521118bfb6587dd2f89"
    sha256 cellar: :any_skip_relocation, ventura:       "664a13ecb97fa56038730724c6e13e5db145df283ca54521118bfb6587dd2f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d4c61cae143ddb0cdfa99bf8496c063d30768c898343fc402efba5470f6be8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_path_exists testpath"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end