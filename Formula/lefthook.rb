class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "c66a7845d4c47485994ae5e0688317fc804c8f3fb6e7cf8d30025ba80b41ccb5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afb091afe7791214e26a19dc638961ab9aa1a45c87778ba32e9ed66d29c82447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb091afe7791214e26a19dc638961ab9aa1a45c87778ba32e9ed66d29c82447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afb091afe7791214e26a19dc638961ab9aa1a45c87778ba32e9ed66d29c82447"
    sha256 cellar: :any_skip_relocation, ventura:        "6d892710b84f1f216018a4d5adf0455afc68c9980624b922f59122832ce34168"
    sha256 cellar: :any_skip_relocation, monterey:       "6d892710b84f1f216018a4d5adf0455afc68c9980624b922f59122832ce34168"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d892710b84f1f216018a4d5adf0455afc68c9980624b922f59122832ce34168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c24328e4f4568dd63db3055bc49b9440974a46ae27eeb1fffaee6e8c6dc22e"
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