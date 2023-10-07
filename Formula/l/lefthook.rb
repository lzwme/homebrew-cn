class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ffbbe1978160f874febe6eacfed740caf221997ca735299f3de0c6f465d7d80f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15be9259fd9d342667e86f0aec7a2bb1e2542ec136066046cd13489aee5cbab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff3608d2997782d3c55f1655e020077067f4fbac77a3baad3222a2114c35e8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed7f0fe89aa881cb8be44e697c336ed1920bfdd8b54b0b0151c0bae6e96a0c8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbeeaf05e65e511c4f99ba0835da47bd1e579e9e2d4a4ffa91b9136071817240"
    sha256 cellar: :any_skip_relocation, ventura:        "d8ff8ac71c3c6ccecf27d96978d48aad4b20e46b1f10706522863eed655ff6ac"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9f14736ecf4a149c25af5de31c8dc54fcccf6059dec7361a7c0e3253610495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ff5f2edbeff4925190b4f2d7e0d11c09a5141f31992e7ab2961bca0c64f59a"
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