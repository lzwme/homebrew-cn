class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.27.9.tar.gz"
  sha256 "4ff5c5099aa75f022ec064b6e8fbf5785b81d7e9d5334491a6da56b4183be4df"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32f6303d824e648a075aa7d40117291417dea65ff3f95de95cf931c7ff758536"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84323e5955e71af6caf9c48d983368de4ee6e9d4d5239e725f000b5c37b6ba55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6a1ccee1f7ea53def9490f27a7b621f021f3292be08c83313a1da90e17b54c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a134c4715831dc3d3c6471164ee037d46bb48d7d9d1c333459fd96656217b7a7"
    sha256 cellar: :any_skip_relocation, ventura:        "f56d44baf41cfa30968c2d90ff59477f4d7698d087574cb0bbbdfded80d1a396"
    sha256 cellar: :any_skip_relocation, monterey:       "f7726d0eebf6beb26bc26bcc1f12558cfc86133acd3e6a14ad350d534aa4ba7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1b9b380ff18506f03d26d0cdc6413603dc148ca8632fee9611c2958d26ec19"
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