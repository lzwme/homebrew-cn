class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.11.tar.gz"
  sha256 "4bed4554f4978f689e3a22631e71adf6cca81015a78c5eedb697514e26536dc9"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dba71280a9605a39f68f6b0b69f5b02193398b29634651619d6c30f04fa5e2ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7566c44fed466458bbbc0423e6341051742f2ae3750b72643b8e3cafc4f0e8a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1e91867d39ff58e99166e279ddb89fdfc7f37577e90093ab0fa661908debce7"
    sha256 cellar: :any_skip_relocation, ventura:        "41eb4a5db652f8f4d09d6684a1dc9fd3117488184ff5e6134e4294a318a73ddd"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f3b99064e6e4ecfab4cd0e0b8975f787c550996d745410a8ef72b4da5f3dc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "41912355321adf427d5f47c81190231f640f3b0ccedd4bc19c6962f011a02423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b8a48806ebb344309f4d820295db35f93bf152533b25a4e01be0c3d8997bdf"
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