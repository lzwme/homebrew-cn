class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghproxy.com/https://github.com/syncthing/syncthing/archive/v1.23.1.tar.gz"
  sha256 "2e1f1b146f18630a3dfa1480a333f39366d855dc6749fe23dc029a61f5fe4cd1"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f99b50924f35ba44663ff155e5145fe208082468bec8b27a4902318ab1d2ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9732af6ea84bd42f920faeb32832fadcedc5f59c68796241e2bebd0d42d07b5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8d4a6349fdd99b654e8e811e3415503e342be57df18c78c53bd2c6b8e9aac2c"
    sha256 cellar: :any_skip_relocation, ventura:        "b7cd29949e4179fe899d67bf626392688b305a59920876837330ff8b4433bed1"
    sha256 cellar: :any_skip_relocation, monterey:       "f68abc5b36f103daff4f608be6fe649496216eaf30d852e3c60da96c57cc93b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2071bfaca4e5fab7acbe0b591025c0d142cd1e5b696bb8713ca44dc5db5efc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9b690ed914f9ea87bbead57374b9a7bf948a271435be3593d187b2a72621fc"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/syncthing/syncthing/pull/8769
  # Remove on next release.
  depends_on "go@1.19" => :build

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