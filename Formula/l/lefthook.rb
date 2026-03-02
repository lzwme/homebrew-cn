class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "7bb7598e01de4832f3a0f33d50707b2f92c5c34d82eb7ba5e17676fc571ce1a5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8449fafd00d4f4ac70b2caaa2cbe3a1353a9c5c087f0a2008ab25f8213c8e1d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8449fafd00d4f4ac70b2caaa2cbe3a1353a9c5c087f0a2008ab25f8213c8e1d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8449fafd00d4f4ac70b2caaa2cbe3a1353a9c5c087f0a2008ab25f8213c8e1d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d9f9154f4a4435757fd44e1ee99670ba7c6c06f7856b11a6d0b3ffc7693ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5ca58f7d3c57f4075fde83b3b24a0d6da05d8ac1d427ed1a16d61c084818190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a902b3ec49be34693763a6c7f888f0a23ab9d8d79ba4795bb40d593ac34fef"
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