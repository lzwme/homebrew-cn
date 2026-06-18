class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.19.tar.gz"
  sha256 "fcd70517ee04eb131e5210dfdea47da101b6afe3d8079a22e626a2715448e168"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ddd2f09fd5a1dc4de9251faa67b9c49e24d14442d59ef7c9c60c123df46dc89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ddd2f09fd5a1dc4de9251faa67b9c49e24d14442d59ef7c9c60c123df46dc89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ddd2f09fd5a1dc4de9251faa67b9c49e24d14442d59ef7c9c60c123df46dc89"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cece153b448b58ae53e47c25fe910e8ab4a6b520b095bf3037f599afd664b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da689bf9ba532f9bc7c5d45fef5bb8ec15c0e5b0d4058b2619f1c42e99aabc9"
    sha256 cellar: :any,                 x86_64_linux:  "832039fbcca7ded37d88db62eeb92c3ff9613f93f09b8c76d9c99e7d55a13e1e"
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