class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghproxy.com/https://github.com/syncthing/syncthing/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "d454be5e6e0aa8fa86817c46c0a80685027f9bee6ca5000292ea4ad4115fed67"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f490f0768d2c4ee627f917c954842b8dfba0912b07c5a2bbe18cc36ca323a4bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d40fea0b5f896903108fee0cbba90a5204717a02d17f9ffb2813b964bab339c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56251c6bace319f550c4662750db98f27309d67aef0c4f4a8def8556c7144349"
    sha256 cellar: :any_skip_relocation, sonoma:         "f083eeb91087cfdb7168f366e1c8832cf78e28a54c730fc0bd027e366d01890d"
    sha256 cellar: :any_skip_relocation, ventura:        "ec5ee9507f578549441dee643017b68ac48000730d56e8b9dbbed7431c10c2e1"
    sha256 cellar: :any_skip_relocation, monterey:       "14b0bf24aea80e1b43ef9939bd44a9e469ccdd59fdce20d6a76510750bafafa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d36a327c3ee7a7df603183b98e37cc93f461ccd54c93aa0c5f41ba66000eec"
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