class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "57758177df11ff323bea079ecfad4a6dbb6a632fd12cf7e8bbc04b10b786abbf"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c60a8636d863fbb2e6cde54936259f8e7e33612ee5ffa4c6bc6799d29f6b54a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60a8636d863fbb2e6cde54936259f8e7e33612ee5ffa4c6bc6799d29f6b54a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60a8636d863fbb2e6cde54936259f8e7e33612ee5ffa4c6bc6799d29f6b54a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b24fd19ed2f9db7c74733f85fc53c0a841e042db55babe28005765524e200a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf97b483cac8b863de114dc34cf8b5ba8c948e8f6d8a13201b78707812d60b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7faaf6cbc3b3a3cda3e7e2e13870845f7b4eb1e1ef4f106264368edc8b5172b"
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