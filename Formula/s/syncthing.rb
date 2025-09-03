class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "02b8a1d8591a687ca15fbd95267e05bcb33c20607d5287b005ffd379ebfb8d23"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f8f6ed2cef413f153c9e93ffbdd81a22c1e7cda74e39066813563f74fb4eb33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67fedffc1d3dd418a674031de8acb7c8e406d8e8d533d66238b683f53e332336"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "febae7570760b78aee3867d65553ef41b62b9f10e01f107edebd7960bc7f77bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "91940bbcc232c2c2b18bbeaa73db2d1ffe8fa789e686db25041b480b8e24cc50"
    sha256 cellar: :any_skip_relocation, ventura:       "d13e0d07459088f6d6e304c6886501fcf45d53c322f45e3d9f96f84410c0073a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb7a52d49c8f4c3e8ab388d470d605152ef6b286dcf38dd32277748f5e3e1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51b8b7797f80bd7293feff8b2ed1ec35e1f204d563d35c80e0575bd2df0dffb"
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