class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.10.tar.gz"
  sha256 "ea60b842b372f3ea5a7a8c4c2937bb5d2ad3130a72596eb195f14fb5487e10b1"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f64be2590ff46612e3b4962b338963936834a0797a8fda595f3c7ec9267a5441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f64be2590ff46612e3b4962b338963936834a0797a8fda595f3c7ec9267a5441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f64be2590ff46612e3b4962b338963936834a0797a8fda595f3c7ec9267a5441"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9603db8910baf9ba126e6aa6d3f5895c7a7a13a1857b77dde40169e1071e413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "648735a6d1d6601e8a72d60dbbe4e1448fdd22fc8867f838fa1688d36b773695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebab65328ec469b99ac888efbcd1c3cca6cf464aee2b4fc1f7a34edb5d69d962"
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