class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "acd51e125005e45aea6d6a65a7bae4881ff781912dbfa7be2745eb6bb7c8102e"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfd20f0bb95cb30b859bba9761d78dcde66676186830c182c26fba26d63c46b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfd20f0bb95cb30b859bba9761d78dcde66676186830c182c26fba26d63c46b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfd20f0bb95cb30b859bba9761d78dcde66676186830c182c26fba26d63c46b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3bf5a71c189499f1b135fdbb5155e2e1bf389a9ec1cc1a952e5169e49a86f93f"
    sha256 cellar: :any,                 x86_64_linux:      "13d70122dffaad80b344a80993f5c056303ded7c34729f1d02fe5e96651217cf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end