class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "bae3f57899e7c0adb5f6dc238558b5544fbf37631624ea17d8056e5e80b19697"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "224a1bba3fa885c0d03329442a9c3f5a5c6bf438b03ce1dc41688e81e630335e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "224a1bba3fa885c0d03329442a9c3f5a5c6bf438b03ce1dc41688e81e630335e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "224a1bba3fa885c0d03329442a9c3f5a5c6bf438b03ce1dc41688e81e630335e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9da0566f808f16a45201c4fe35ccfb6b2af13abf278b7793fc5295e3e60fe33"
    sha256 cellar: :any_skip_relocation, ventura:       "a9da0566f808f16a45201c4fe35ccfb6b2af13abf278b7793fc5295e3e60fe33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "250a7c27fb73e00b1ab02a98f43d8912d00b56d67416a76435c70d11818834da"
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