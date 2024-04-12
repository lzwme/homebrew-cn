class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  # Switch to github source tarball on the next release
  url "https:github.comlogdyhqlogdy-corereleasesdownloadv0.9.0logdy-core.tar.gz"
  sha256 "bd55b3cd380117288112403a19f4e7deeffc667df8970425c5e1ce8b87848720"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4cde6e80a7c7d933c27c9973ad061d24b75b70dc8c8cf2b85bcf701549aa37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86d900c9a3f2f092b72471944a97805863e6ae81e063edf10bfa7ec1f3e6ec1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0f536e387573a90896ddb42f49a8594ea222dd42b139f78a1b799b7f8c3acb"
    sha256 cellar: :any_skip_relocation, sonoma:         "5489a9cae84fe47a636788be1b938e459e3cd027551f2b4d3c8ae6b0bf6dab77"
    sha256 cellar: :any_skip_relocation, ventura:        "14cb2c6563394afe5ba9a0bf02b3e45efe31d5ed888ac9db781c9c2328153ca9"
    sha256 cellar: :any_skip_relocation, monterey:       "8a53141732d63f8bf19d379b7b53d336f73b650f308a07c27754ec87a0d2f347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cae36eea1b23315d8de971831d01b7da43cc4a0959e1f7768eab13d1c64d5fb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _, pid = PTY.spawn("#{bin}logdy --port=#{free_port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end