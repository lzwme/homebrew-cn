class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghproxy.com/https://github.com/syncthing/syncthing/archive/v1.23.6.tar.gz"
  sha256 "8b4d127c6893375165bbbc31865735b7cccc99e1bb019f6dab7a6020ba6b621b"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aaa54562bda1529624faf165775f77486d7e7d0a5163e8b3694598aa24615b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e189c1141919f6ab98a42890fe8baa88fd158fa29931d90024fc40d571dfef1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb95114cba8e92392d7eac35f28ad7f3b48034c63663074e1c01efcb9e397554"
    sha256 cellar: :any_skip_relocation, ventura:        "4edd4868ce83a72faa792e949de54ed3aab4c604ea63667cf53300f289d0fc94"
    sha256 cellar: :any_skip_relocation, monterey:       "85ac95d4b89769ebf493c9921a2024f5968629bb3ef9b5bfd7f73211cd8eff5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d322182119766c2fc4fbcdc50a28e67aea5af58384eeb590c7a88fb1915768e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eedb5ffa9c3c2fda2355bbe6a316cab6e72269529a0f9559b8fda35a215ddc1"
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
    run [opt_bin/"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end