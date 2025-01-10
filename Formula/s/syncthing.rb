class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.29.1.tar.gz"
  sha256 "a9446652ce994ef479e8637b797803c7f53dec65d4cf45dfa6a394ff3475bbaa"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028303cfb50071da29912fa14630e600a58ceade8422b8c7c8cf3b55d3a1d1ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adfa5fe00e09484158a29067b8bafcfc8d05ffa9d80fc892a3a2d01e7bc24649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9901d3e78d4237fab3704033d3543a2e68719e7a3bcb6f7ff5fea52ac9e70e8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d493d2bed4d56c9ad10441541dd7ed4c8413392a53dc3b28f0fac4bd42762a2"
    sha256 cellar: :any_skip_relocation, ventura:       "c506b442c9fb0305270b42190c4d2b1dd3b1a3fbb65ff907726131eaa1462ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "735f62feea543413301778809fc7832da60523b9b795eae0912d2ca4983787a3"
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