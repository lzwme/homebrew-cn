class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.12.tar.gz"
  sha256 "30144685dea371075234fd3d9865d4f5ee25b5bed4bdfa8fd2f7481188e3fb09"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a72c41ec5df898c00b4abe6ae14c77a603f8944637d60f21f8e29986175a01a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "709738f31848139df11b563d99f8129fb3ed69a3d808c7308a7543e5c9ad26a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "055ff1f6afe54b72912e2a189b0fe83da05ec9c67d2b75646b98fbf4289313cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b46c57d01b619b9571e33d59badbb0811a0f269cb012afa53e8ac16a28eab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db3643bf07410f209f19249e2b86c6968eb251f77aa515f824ef83feed0c6651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d722618ab290f1a1cd88309939582c1750a08cf697aff955098103539d3087"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "--no-browser", "--no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing version")
    system bin/"syncthing", "generate"
  end
end