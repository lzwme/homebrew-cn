class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.11.tar.gz"
  sha256 "55579193933e95ec9161d93f9e9a289ec1337c257249a7804c38975fca6c8237"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06f2696259a66b3dfa2f18659a76364ce778b46f3dd5cbe81857f9a196ede04d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06f2696259a66b3dfa2f18659a76364ce778b46f3dd5cbe81857f9a196ede04d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f2696259a66b3dfa2f18659a76364ce778b46f3dd5cbe81857f9a196ede04d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f85f410d6b51a2d8cc2378235888a138fbff5c3018a2658707a661df474b860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96e3d410e4d79d7bbbd49d1156f79259490ac1ce3f8afdaf5c8ec2605b997ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a41536abaaa61d83ede7b8f495d3b3f05694561bc9b6f7fa9350d5d0664cc5e"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end