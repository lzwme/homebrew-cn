class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://ghproxy.com/https://github.com/tcnksm/ghr/archive/v0.16.1.tar.gz"
  sha256 "1c61fa3fa7bd57e140e6496fb43526a095f006b96d6a4493a1cc2a40caf5535a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d46398d9ee792091bfe633e11095e8d084f05c1c1fbbbb56dabc77743958ed62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef0c362115d6d056b74ecf01b8b15a40faa6710b7b6d5d21926a683406594376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f3007c4e16cb36f45d1f7efc2b68bc902cc042c73948777675b4e0da851ef7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1459d3084177e4ced2f4d0a3d94723c450c42c8b72500d98284ac2bbe62a6cbe"
    sha256 cellar: :any_skip_relocation, ventura:        "93e66bf0bb5c96c288ba7e8ca029fd2243a3756652165ab43a739cd8afdd6295"
    sha256 cellar: :any_skip_relocation, monterey:       "b90e7a9741181b6c87a69a0d61b21214e968406b7bb1047a1028af8ae1d29865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1780a881da85e50a07e856e695b3c36786c5c3a7c77539e512f448b8e67880ff"
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