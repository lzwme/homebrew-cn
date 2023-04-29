class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.12.tar.gz"
  sha256 "6a61365663ca2be5d4b89fdcd0ecb93be9a19eeedc26b48512cef43dadb769f9"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a16003a2b06a2cda35590f4175fd23a4b30cdf7eb09e5236e4ce7d39a217022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a16003a2b06a2cda35590f4175fd23a4b30cdf7eb09e5236e4ce7d39a217022"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a16003a2b06a2cda35590f4175fd23a4b30cdf7eb09e5236e4ce7d39a217022"
    sha256 cellar: :any_skip_relocation, ventura:        "5b7021ed6c0b0d429ed013a1fb9e9348e26f42070e19855bc496ab65e8e12f76"
    sha256 cellar: :any_skip_relocation, monterey:       "5b7021ed6c0b0d429ed013a1fb9e9348e26f42070e19855bc496ab65e8e12f76"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b7021ed6c0b0d429ed013a1fb9e9348e26f42070e19855bc496ab65e8e12f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dec6807e9b64b91f8d51eccf12b9cbeaf7d30b24b8c18ba96decb42d66d3ad5"
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