class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "78d38211b1f02bae0882dd9bf5c3cb976deff50124024a22eb922613d53238db"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6736362d2dd26535dc903ed39cccbc8ace59f43df35d03d8dc5e5338af098f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac040a82ff1f3dedac5d71360bfdd68c5d0b22cb8df2a90ac705715187455ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3711ca19b55e14fb3e9e0657ef3c6bc06a75cc31dfdb59267556df5b29e09cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e977491285438037b29250b05857c84dc9225437e954c89a6482450fcc0afd1"
    sha256 cellar: :any_skip_relocation, ventura:       "95a062c0ccdcb6c6c25665748618c7476a0e30eb353fab088f6382ac000317bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a76892d0d8efede02327a47c1ba63e535049a0bf0626bbcef57685f1d0ed3142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4efd249f95d532b1c27c60142bae49e09951653bc89cc439cdbf34de5dd27289"
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