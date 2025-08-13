class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e5bdc6cbc9d671d6c1bfcc0c778bd4d591ebb491fe07d5f7a1c19916c8742df6"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9a7398865f1370640a4e898289145074b226b1146fd70191e54431618207e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b28948073445bf1b3cf45e7b12493a05eda95f62fb5e258888016fcd44e8d95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4caa5e74219fede948457f858c714f86c992ce33271ae2bb0dfa98475868b3e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c33134cb338959e7004c7a0ea91677f5285e6c95949904cb4397aa0c26dbb12"
    sha256 cellar: :any_skip_relocation, ventura:       "c91529044134bdfd2dcfcf2f98ba5f469080c69e192fa084ad62bd328bf8da37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8456b0cc00a370f4cce8314b1669fe8c234ae00d8e7bd92a00bfe8e811171e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ad2092ba81ab9428635f1499f5db9a1f1313207046a10aeb58318c1a2e133b"
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