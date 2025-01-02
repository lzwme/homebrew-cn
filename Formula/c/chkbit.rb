class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https:github.comlaktakchkbit"
  url "https:github.comlaktakchkbitarchiverefstagsv6.0.0.tar.gz"
  sha256 "a95d6faad4b292b5dd16789fc2cae1615dc77c6ec3923067d56d228e2bcb8d8b"
  license "MIT"
  head "https:github.comlaktakchkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77998a9ca4836886652028173813a941b661808caeb1efcf58c58a658d3694ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77998a9ca4836886652028173813a941b661808caeb1efcf58c58a658d3694ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77998a9ca4836886652028173813a941b661808caeb1efcf58c58a658d3694ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "088a0163ebee17be07ae738340e0251d5d0398701a5eea27c2c297beb84cfa3d"
    sha256 cellar: :any_skip_relocation, ventura:       "088a0163ebee17be07ae738340e0251d5d0398701a5eea27c2c297beb84cfa3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a863fe0bcaf71b12f471cd8db71f01900ac5ed812658da4028f3d371914e51d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdchkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chkbit version").chomp
    system bin"chkbit", "init", "split", testpath
    assert_predicate testpath".chkbit", :exist?
  end
end