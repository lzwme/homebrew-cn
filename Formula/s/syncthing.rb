class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.29.0.tar.gz"
  sha256 "2d2ead8ada92e48c9b45a62e1c85b781214579d125bf04c8a95859760c7db71b"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a019b72fe9de68bce6f7a5961f1cf987a441983b7e9a4bd2dc926962815813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b782554a88261084dcb7f3145ede739f5cf40c4f485ac7cb4fc43669a51d030"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "146a052541415fd0c4480e8c0e0bc2fcd64dba8f25f33da3c909d60890fe4477"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4de7e1a3dfcc4870c5e3f700c54597a15a2ce7715cb2ae5fda0240bfe2cb488"
    sha256 cellar: :any_skip_relocation, ventura:       "b7b6dd197995cb83478e806ffa818bb28d55b3252a5435d90a2546573f05fcd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9957275728f371365a04b8dc584928f30e4324810badefbe0d188e01c3472a9f"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man*.1"]
    man5.install Dir["man*.5"]
    man7.install Dir["man*.7"]
  end

  service do
    run [opt_bin"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var"logsyncthing.log"
    error_log_path var"logsyncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}syncthing --version")
    system bin"syncthing", "-generate", "."
  end
end