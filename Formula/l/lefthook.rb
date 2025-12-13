class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "e22c02c8b123c059d3f482ded33af71e78081c705d16cc6c42256a4d214d22d2"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a4622cbf7b998e0dceab60f9595dd8a221cbf3651631f7b6442ca869b96121e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a4622cbf7b998e0dceab60f9595dd8a221cbf3651631f7b6442ca869b96121e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a4622cbf7b998e0dceab60f9595dd8a221cbf3651631f7b6442ca869b96121e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4eb13b664926cff1e1f678e8e6d1073754dae0258345e75fc286209305f965f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae831507263360910046abd9a44323d0fff36835a0ea85c5be5d88f9a187717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e465a8aa0ad64086cffaf2219d395eddbeb756186a12e358d2f1bff08fa4ad7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end