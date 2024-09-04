class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.27.11.tar.gz"
  sha256 "b1d52d4b975595d6f5af694788d9025a62599b73dcf4b98c398129df7e731780"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "645ad5b0f0e9eefbfce01e470dc6774afdcf49da8f9705b4f19927f160434142"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a0241b8a10b8f1acb846478d63186f0e76d159763350b852d5b4afbf4fcab77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23aa0c868234109fbbd3514a8e77ef9e6ee32c4c02128f14b731ec349df70ddc"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd6685494739c3bc5bce6b3e614661402a207bccf9c83768b9acd1082b9c10f6"
    sha256 cellar: :any_skip_relocation, ventura:        "ea7814e22645f3676c8103b7823730a0793ecffbf0b96d5af628d25354501f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "1053b21c07a39ed3b4e18128f081ad3b3e1444c595185d3e431370fa1c8dc7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f07b04b08a74fb82cabe929865994ec2000e7eaaef61c93684c7ec060eb906"
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