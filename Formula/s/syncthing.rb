class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "c72262641aabe4ec2dcdda08dfb41f8a5035d8dcbfd1e8d0b35113b332211938"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "537e30ba2c44b6e5260cf1125b0c6cdcdabcc2f3e60becd2e84072c4b23837ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d362243474867b0597e3bdf260940508c6dd32d9034381306e8b3a1ad0c475"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0cde493bc111502c85740693ad93dbc4f04e692e7c184819d71194bb53aff40"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a84ef3f01c5d7ca5a4e3f0dc64ed58d6c04596ab852d846c4ffa6609b15bd33"
    sha256 cellar: :any_skip_relocation, ventura:       "1392dadf1d25fc47e22664a1cd825a36d061e4865a7d45b944228a181bb0d696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57930f8847e24e3fd1f83256101c62e9ccd2cc2624818e4f4dd0866ef69c05fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e76a7090c3a0106eef0104e8fbff07eee8242b5784bbde12ff985f2dd5cd0e2a"
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