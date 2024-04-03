class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.27.5.tar.gz"
  sha256 "833dc5ade78250e3ee2b8ce73237a6e980f732a5a9d8fcfde6064be781fdaf30"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d682ec9fb6db4ef0628d00e13fc81806f0ae6738ba85a3311921c62de09d07a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "677115412355e0b49a05c490136795f8438dc81fb129cfdaa1a9d27779c7169f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49618e876065eb3ab8de6bfc8e60e578191446ff9b75b1b86f524ec2353eab9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3fb62f4add6ba26a859a428293406ebca6c2a5e176273fb017de777c2d7cfc1"
    sha256 cellar: :any_skip_relocation, ventura:        "24b47338a840f1c026e4962da650e71b6207c2cbbcf2cb8a0c027eb020af75ff"
    sha256 cellar: :any_skip_relocation, monterey:       "5a048c7cf001a898fb6b33bf751a8fe406f68d438d697016f47efcc32ba86c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b08b9b385c57e86d61e088cc986e46b960ead3fde2e9322b2625a270f4a3f57"
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