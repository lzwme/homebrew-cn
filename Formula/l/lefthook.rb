class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.16.tar.gz"
  sha256 "ba99fd7ae175120f94e6533dccf7bbe1b0f842b57044211d1f454d3b4be896d5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed30d9393b994e1600e888ef6f56fefb21d39a93ccf81f76af2298f21fd55adf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed30d9393b994e1600e888ef6f56fefb21d39a93ccf81f76af2298f21fd55adf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed30d9393b994e1600e888ef6f56fefb21d39a93ccf81f76af2298f21fd55adf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fa2327c6553e9977053c9f94e40cb3fd9a250bd611247da90b8922bd28edcf3"
    sha256 cellar: :any,                 x86_64_linux:      "6940355ae4fa1aa2526dfe9efd225166280d7123b8202ecaa167b2f7e8db8d1d"
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