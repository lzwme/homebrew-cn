class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "6c05c91b14ab541e65c7ed853ec1540e1aa2c2afeb61ac6e85001f6c2d0a3e10"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03a611094bd6cfef59482b8880e68377765089b38c633f1f76966dfa56e2fa6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03a611094bd6cfef59482b8880e68377765089b38c633f1f76966dfa56e2fa6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03a611094bd6cfef59482b8880e68377765089b38c633f1f76966dfa56e2fa6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e22c6eeecfd1bdd19c28407ed26c6b6a078cda2cc5d5ea7f9df7c2fc27cfca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8749ea102caf9181cfa433dd59422c5b2c9e7a4d4872dba85553d3bb387eb99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c23689c92ce04f052f7f8f263ed8d4f063d173e092f815b6cf684770bcb626bb"
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