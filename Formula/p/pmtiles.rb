class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://ghproxy.com/https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "3ec217acf15f23b3a2f1fdd31fcb0bd8e6f57646d13fb9c24f1cfe8db38f7323"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "341b463c381c2ae0851dcf0e36d3362c50b517d2e0c53aa4275b4f4db91f5675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc908655ca35991e43b02e117402e2e8b6197f89508f46e23d17b5426509b2b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69dbbba6b6c7a96fb4a01f8563ee68cebf0bc56d8713e4091391c828fb1fdfad"
    sha256 cellar: :any_skip_relocation, sonoma:         "a920867dfeb8abebd4d09380823f1fa7c8a91e3c7a65d24ba78374f29c708286"
    sha256 cellar: :any_skip_relocation, ventura:        "ac451035b7c93bb95d687d7f320d0a0b9c58a4669f7a2bc1ff8eb6f66aad819b"
    sha256 cellar: :any_skip_relocation, monterey:       "ac63928b171ada8e8fb15763deac91c58d46d9ab5a37c6523b136aa22dd1d742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1445c8093cc2bdbddf8444400cd96f22133b2587fa4a8ef654de1f9d329ee5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "404 Not Found", output
  ensure
    Process.kill("HUP", pid)
  end
end