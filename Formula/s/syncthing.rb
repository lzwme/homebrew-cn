class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.28.1.tar.gz"
  sha256 "737f6978cf28e891aa4fba120b6f8fa5940d06eabec187050eb98c6645a01e10"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a008db968b1d811a22a3ed115846743113a63281af6ef665c1db8023fdf9b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c87ad71112c13d6dae9e4c86405177f02dc819b499ef12fa98eb31598be3c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb8bb996586e61f449db3671fc2eca105f5bcb790477649c6cd1689f3c1550fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "614f76564fbf0349e3595d9e3b6db9e85792330fcd2c5652c2910570ddfc0c37"
    sha256 cellar: :any_skip_relocation, ventura:       "be23f059ec99859d0c831b617c8fe572036a7198cde14b6defa5418bda8555fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "295a477f57a1dd162184a019fdd9a53e85893e42bca7705f54fe04d72e1dfb42"
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