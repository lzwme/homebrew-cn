class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "e9fb56161a9d33a0e273d8784493f071a0a2ad41842f6797436f13bfd7cfd63b"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcf616444398bb1ece3febff9b0da795fc78f37618eaea010f32681422ad0a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcf616444398bb1ece3febff9b0da795fc78f37618eaea010f32681422ad0a06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcf616444398bb1ece3febff9b0da795fc78f37618eaea010f32681422ad0a06"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac9ca15aa2523b2beca8cc47983ee9c120ce9cfd79d614bd780dbf8a0585b30"
    sha256 cellar: :any_skip_relocation, ventura:       "7ac9ca15aa2523b2beca8cc47983ee9c120ce9cfd79d614bd780dbf8a0585b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82a76d00887d844c5446d9b6dc262a0aea6eef0f9ccb66981fafe1a8f7ef3851"
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