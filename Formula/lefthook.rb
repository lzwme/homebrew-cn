class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "553ca672c1ea0e5a2abfe5613614030f37c03dcdc9b1ee326d57fd232bae1762"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed832807c5d4ef6123fba2d8332ee6bf95dea068eaa49938364edf2f1b3ced47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed832807c5d4ef6123fba2d8332ee6bf95dea068eaa49938364edf2f1b3ced47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed832807c5d4ef6123fba2d8332ee6bf95dea068eaa49938364edf2f1b3ced47"
    sha256 cellar: :any_skip_relocation, ventura:        "62814faf2be9836cebb161e1ef8c8d69bd9aec2344ca6e00129351a6bc568044"
    sha256 cellar: :any_skip_relocation, monterey:       "62814faf2be9836cebb161e1ef8c8d69bd9aec2344ca6e00129351a6bc568044"
    sha256 cellar: :any_skip_relocation, big_sur:        "62814faf2be9836cebb161e1ef8c8d69bd9aec2344ca6e00129351a6bc568044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83d89377613906d33f76800f4f5741fb7db72708f8893d1ee6e18f82214420f"
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