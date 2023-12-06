class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghproxy.com/https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "9a6397be7ff6a6a47c9b2bd7a4d0d719474dd48aea7c2dc65146774ecc525dc6"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15255646a71ea8c1f1ec882e52666b1129363bdbef534f26ac95a694f610df75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5215d60364984dc3816184b4e80610190ed94308e58173645142da541cf13c81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "801a2dea4691b87db3d2f01ef8a2c588b5dabe2f5eb53ab47b55ccb9e70870df"
    sha256 cellar: :any_skip_relocation, sonoma:         "07bf258d405584c0c4127090f8b9b7595f5f34e25dbc810cb3249a019f197aa2"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7d52aeb02cae33654d60327dc9eb079f5d8a7997f57af0096379b3dc64b7f3"
    sha256 cellar: :any_skip_relocation, monterey:       "8f8a1c1e3874284bdaae731162fcc274f5e58c9e5be4c692222d4135d3a64add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b801a2333888c94ae0cbaf0e5c9b2987de5183f667bb55d9481bc75af56f9a7"
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