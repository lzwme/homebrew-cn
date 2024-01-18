class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.5.7.tar.gz"
  sha256 "8c111fbe3472debed6e47b7153689519ebc4dcf7b3cde4c2efe31f3600aaa8af"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d58c06b4f000873f52ba98ceb8c9a9b9510b3bb162fc2aa271cba5380ff59ab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78c1c28119e263416b95ac4094aff03fe29eb895a3788085874f7846e8190439"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f7d3441fbe1094a4c00fad0ae804a2317ddc2b60fefc92ffba1153c539e8d98"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ab89997c5499a78b187aec9e7567aaf8e11f83761193ee3821683aa1dafb124"
    sha256 cellar: :any_skip_relocation, ventura:        "f672b7eed89f7ddf589ca760d331651391e13c108b8f9776d0fa27492c725883"
    sha256 cellar: :any_skip_relocation, monterey:       "97715a17d509836ab05484ab11892d93c1347756e8fd6d885658f2aa687ef3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8416d0e5e53ffd8c2be1ac53ea6c0567bad13831fb53a2e3f9b039d2d1163901"
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