class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghfast.top/https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "525ac1dd6fdc9e04f165b4e34123b261c2e4a8ddde2bfc914ca8f33c99424cde"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830b18e9b2956cbe7b70195cb66225e8dce1f973af667cc8865c2c3dc6b7786e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e096136836986da8fe4691fda4c05a832b6d6363b657331e44a76b7efd8b6048"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c006b08427f6772f5141b0160e1ae570443c9b57286b4c34038ec3172a31cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a91f7e15146574a813692a3151a68c9da111544fec41341a3eb52924de76473"
    sha256 cellar: :any_skip_relocation, ventura:       "b933147a0ea89526f52df3cf48e20d0e29a7090264adf5297cee4d1984e099cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a9e6a81a592c8e2a6e81eca305fe27ac82580cb0a7b4d39dc6fe5e662405c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d46821ed92484c81b2db07800e4ffde7218be59d8b2e52c96e425006263335c"
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