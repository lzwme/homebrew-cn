class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.8.0.tar.gz"
  sha256 "b699fa04cc09b0f18234f658f527f487e222e09c6688c63f6bcb47a817925aec"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1d0763f7eef0820e1b3045c801d97504651743b17bbb8369024377319be4da8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d0763f7eef0820e1b3045c801d97504651743b17bbb8369024377319be4da8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1d0763f7eef0820e1b3045c801d97504651743b17bbb8369024377319be4da8"
    sha256 cellar: :any_skip_relocation, sonoma:        "213b93d854f3f0e787e2e6911c009713ca358cd847583d4c1a50e0c8544c5c73"
    sha256 cellar: :any_skip_relocation, ventura:       "213b93d854f3f0e787e2e6911c009713ca358cd847583d4c1a50e0c8544c5c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c93672c245e6d5ba2fdc7fa457efc83f58a77856ba9227b836a517ad3e11226f"
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