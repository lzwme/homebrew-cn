class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "9a9a48cee582d056520b798461e61f39c5c17e745794eb0fa8bb37d0e67b44e5"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d75ceb5dea7dc00f9b3cf3b52a934ba2721002c0e5bed4ba23fdb93c29d7ddcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75ceb5dea7dc00f9b3cf3b52a934ba2721002c0e5bed4ba23fdb93c29d7ddcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d75ceb5dea7dc00f9b3cf3b52a934ba2721002c0e5bed4ba23fdb93c29d7ddcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3be7a1be718c52731b4f7696db598eb017c6944790980aeb24cb791c49277778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79bd9b2cc2e3bbec936023d4569261946ee8df95ab5907227c30e2b7b61a7642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb155d464a27e16b143cd7ebb090c18ddc7ac5258d3fc9cfaee93e23bfbdd3e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end