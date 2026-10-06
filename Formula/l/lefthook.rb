class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.17.tar.gz"
  sha256 "93b3bb1b52e63194b287ba6ab921a5c07b85f4911c8c9295dfc73228194c6789"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1364d9e543f653c88c091e38a89eddc05dbb3416938f4510c84b3f913cd984e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1364d9e543f653c88c091e38a89eddc05dbb3416938f4510c84b3f913cd984e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1364d9e543f653c88c091e38a89eddc05dbb3416938f4510c84b3f913cd984e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a007fa787c9cef384422a3cde01e97c5be5b60716d9934cf247c23d81221ce98"
    sha256 cellar: :any,                 x86_64_linux:      "57a972719e5bc5337f1bd011ff97505288b1911356e2e644d826196d40de292e"
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