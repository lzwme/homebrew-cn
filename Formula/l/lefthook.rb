class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.0.tar.gz"
  sha256 "427dd33e5913278b4802e64342831f725bd5255a55b6b126d423d38caaa0763b"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4256e957a9c96715e3f09c6c9224b977c12bd6bde3b456ac96c790824e6aea3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4256e957a9c96715e3f09c6c9224b977c12bd6bde3b456ac96c790824e6aea3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4256e957a9c96715e3f09c6c9224b977c12bd6bde3b456ac96c790824e6aea3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc4a161a2f8b198cfec4bd7398cb3ef96478c560ab26f4b9acb5fa5386fad99e"
    sha256 cellar: :any_skip_relocation, ventura:       "dc4a161a2f8b198cfec4bd7398cb3ef96478c560ab26f4b9acb5fa5386fad99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d9d9ff90b0667af3bf4a9f5350b1b6c03bc3b9be7921ab7f4143e18181286c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_path_exists testpath"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end