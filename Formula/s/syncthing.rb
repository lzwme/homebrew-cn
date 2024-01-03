class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.27.2.tar.gz"
  sha256 "a22817aa73a2a7412196d7daa20c88738b3d02e6dfb0b69338d8646f6f36e400"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e64fdaf30bdcf0b234bc9b6978b065b6b547e9c34ea27bc85689c34419f19d4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bea0902977e8e024128a4ec7a3761480f03434189c4703824652b2b40f6bc9fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277926b7a710cc3fe7f79825105f9acbe1a3da092d77d46e1d71bb8f3ba4ca2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "144e59e9ac1517417c120f05c574cdab5b24479e8bb1a500c1a6a3665fdbf7b1"
    sha256 cellar: :any_skip_relocation, ventura:        "a67278d8ce5f3f2e6237375bcc7718f777c4617acb1eaf238b9bb8f5bb75e901"
    sha256 cellar: :any_skip_relocation, monterey:       "e275b7f1921fd1e18719b96b32e4b969013a096bacc00c56a332800c71a97d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b2961301fb6e8ede3853255cbf6b962655ef6d41a1b14039bf69f909d9cb71"
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
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}syncthing --version")
    system bin"syncthing", "-generate", "."
  end
end