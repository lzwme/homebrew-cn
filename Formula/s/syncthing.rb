class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "b5f61ee87bf999480522b872ab5f9c7246c7818e792d1e2984940c4f3213d572"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca73d94e0439baada6a47773bb73093ea8a4647bebf3ae1d2e3f680bed637140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b03071b553129ff717950f153698635b49b2eafd8713a8dfcc7e237bf86b71c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4566344e55da45f73db4305e7912a4560fe4d8437f5ecd332b74398b0dd48dd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3063a3e8fb1a3ca0d59b6deb5051b5ab3bc9d4f37242bc0404a4de6c630d40f4"
    sha256 cellar: :any_skip_relocation, ventura:       "a4f9e7fa39eef0cc34c89244c46fc45965ceaa7df656bde061eee66b447407d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31a4fe87785911f6f7aab755a97390a55f6be2d4ac5c87064b40f57eab447d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5485eb1e70b8df39595b3651ef2de6f54ac0514e4e3c8ef50b6ef175440b6359"
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