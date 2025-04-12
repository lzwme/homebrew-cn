class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.29.4.tar.gz"
  sha256 "6fd5fb081297bd031923a7f9b2a641c38df2bad8cf65e197d9bcfc2fc4bf3a83"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4e35d603c96740df5eecb632818269c85f5227e926e1be888cf49aa776376f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4f5c5c8bdd6fd7953bdcd05fefa30c5b8b2ee240fbeb4a1953ab9ecede8c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f74c9ee5dd0a7042a8e9955eb3820a6fb49e181f1eb0ab204f6eecbf0a87c6f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2cb5ab61e4c2e883bc4d783e6a7586d1a620f4e38e4c6702e7238279555d97f"
    sha256 cellar: :any_skip_relocation, ventura:       "7029700bda1f159ccce156fb08fc4df2ac97bdf8d8d597aa009ef1d4d9255ad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f421f8dae24d4032247ec62a48236095478cd0ff8cca567ad8c117fb1d3ecf3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc08dbd6becc7e15d81b6c3fbfdd3c9d1dfc9fdcc4deb47165edc57f773d169c"
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