class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "92ca652b862b75d1fee07764bdd4244a9c79c454876ba949f679fa765187a0da"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78b7969b411f2eeab370a1e689e051b3865e096fc23862e69037ed31cec19a3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78b7969b411f2eeab370a1e689e051b3865e096fc23862e69037ed31cec19a3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b7969b411f2eeab370a1e689e051b3865e096fc23862e69037ed31cec19a3f"
    sha256 cellar: :any_skip_relocation, ventura:        "5352d3fcd4f87c58ee8e8152df31212f15f4c776a92bc4fcbc9b65f803099539"
    sha256 cellar: :any_skip_relocation, monterey:       "5352d3fcd4f87c58ee8e8152df31212f15f4c776a92bc4fcbc9b65f803099539"
    sha256 cellar: :any_skip_relocation, big_sur:        "5352d3fcd4f87c58ee8e8152df31212f15f4c776a92bc4fcbc9b65f803099539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f9cbad114c7746c4a5d31e4f52e01bf26576a14d951c80938f2ea7ea36c6e8"
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