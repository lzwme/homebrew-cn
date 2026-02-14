class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://ghfast.top/https://github.com/tcnksm/ghr/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "aac4c0cbff1b1980d197dd41f0cabe5a323a5e2ce953c81379787822921facf9"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0108a188c7499c9a585cc199ba6803badc8cd56922863d532b583d1ef012c123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0108a188c7499c9a585cc199ba6803badc8cd56922863d532b583d1ef012c123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0108a188c7499c9a585cc199ba6803badc8cd56922863d532b583d1ef012c123"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f787564093c774b7f1deacab6e3ffaba5682bc615710e84366cbcd17719b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01637a1ae92bbb6a559b42077ecaf0200935c55788ef2aa3f16e32424cb2e832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab6ba0720f1330d175b7fa6abba738e3a022604834b35f554e4333493f2d8e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end