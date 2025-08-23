class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "ccb5524e27f0c19c225275603bf2390bb0a1663ae63863f766303204a62cdce0"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b55a0c2eef66d579aec249bc0ec1b34d81c744790c6671b652a4f15e8e7dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b859f2ae27daf35ef5c62a5b0fc9e0d90faf30199ea27152cda1389d2ba093ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "561873c85d53d214515a96a9d2c3b54ae86fcdd4914634c6140823a594f0ece4"
    sha256 cellar: :any_skip_relocation, sonoma:        "884f8b305a534207bfda0b6f09f2b3eacaf751850a354e711d293b7a113ecc26"
    sha256 cellar: :any_skip_relocation, ventura:       "e69d5002d728479301648d4e6cdd9b2281c627fadd595c6f80be9cad2c6b5b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b4121c9aff659c2c3119862e2901398d6c4d98b6be253287d514560412b6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd4f8e907c7a7c227e84a1e8894ec9c6cebbe7ac21b16535305e7aed5525e1e"
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