class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.12.tar.gz"
  sha256 "c2e79ff53d31aaeb5a5765d118552a7b6f6e2667647347200386615ee4e88acf"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e0f57fb52b00ecd9f660b537e964fd45a1e588480e41bf8a5b5874a8ac75f8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e0f57fb52b00ecd9f660b537e964fd45a1e588480e41bf8a5b5874a8ac75f8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0f57fb52b00ecd9f660b537e964fd45a1e588480e41bf8a5b5874a8ac75f8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1efee6c6c3150997e3ecb9a8dc12b73acc3dcbfdae77a658dafea1177be4588"
    sha256 cellar: :any,                 x86_64_linux:  "4f7d23938a325f7e615468daaa25b34fa7d64ab769f9df17ff8ec4ee0683074f"
  end

  depends_on "go" => :build

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