class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "2e2378b2b2a5ea70deaf56c6138a4336b4515ea875d3bff6e1bdb7d52feba3e2"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b77f9d45f92ca76fe0982ffeada876492e1713fd8c52bbea3f8b7b3f6ba99c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63fcd898241a266b27fab437a1fd6d8e50afffa7b01e0cc71a1a4e7dd0b9578b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a37fd442f7ddef1f7160754eb553efa1a5a7a228e890122a535b62d9b09b4bd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "12c181e195ba484a0180dd070cd6b4ad2a03094bd3e3ac2ea79959fc75a9dc94"
    sha256 cellar: :any_skip_relocation, ventura:       "d1279220c3c390a0f7314a6707a7ea993cd7eefad5a841cadf0795a2631d42ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13f315810b020e4808d6e48886e551c0a5ada0d6568f20e523f75fd0fd9fb4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c7e2ad8cf05ba4c383610666c1faa600685092d00904a7449e5dad1d8e53bdb"
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