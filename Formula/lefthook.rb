class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.11.tar.gz"
  sha256 "43c163c7a0f8a4a1f741798f0ca6fb67c010983d0b2f2fc513850d1acc646d0d"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62cd867126df8bdd639e641cc68264f4048453b456cd5fb8a052b79db4dce313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62cd867126df8bdd639e641cc68264f4048453b456cd5fb8a052b79db4dce313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62cd867126df8bdd639e641cc68264f4048453b456cd5fb8a052b79db4dce313"
    sha256 cellar: :any_skip_relocation, ventura:        "5829d240611484c8fb6f666e0470d53243f3a1eb5bebcb7bccbc9e893b18f011"
    sha256 cellar: :any_skip_relocation, monterey:       "5829d240611484c8fb6f666e0470d53243f3a1eb5bebcb7bccbc9e893b18f011"
    sha256 cellar: :any_skip_relocation, big_sur:        "5829d240611484c8fb6f666e0470d53243f3a1eb5bebcb7bccbc9e893b18f011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7175c8bb796dbbbaade2989b53ee47020a91d8ff8682b9c24605ee6f68bc3a16"
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