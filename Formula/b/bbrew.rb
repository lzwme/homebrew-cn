class Bbrew < Formula
  desc "TUI for managing Homebrew, Flatpak, and Mac App Store packages"
  homepage "https://bold-brew.com"
  url "https://ghfast.top/https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "ddf3d5e69da599fe6cb9660c50895b3572f31abb511d25e5d39547e9e7e95ae0"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51687e72efa1e34857d074f63c46c2acd77cf3343ea8ec3a7e5b721b3f96d183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51687e72efa1e34857d074f63c46c2acd77cf3343ea8ec3a7e5b721b3f96d183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51687e72efa1e34857d074f63c46c2acd77cf3343ea8ec3a7e5b721b3f96d183"
    sha256 cellar: :any_skip_relocation, sonoma:        "49fae21e7e2347e62bd5cf627fe134f36e80642fd95f823b5eeac33a534da7e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfda2386161a27d17235c359279aa6ac5349221cacf18a781638a555548bbb54"
    sha256 cellar: :any,                 x86_64_linux:  "bc3cf853eefedb10a357db3314b9610ae964c127eebb7c6ac9e2d3326b2b416f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X bbrew/internal/services.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bbrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bbrew -v")

    output = shell_output("#{bin}/bbrew -f #{testpath}/nonexistent.Brewfile 2>&1", 1)
    assert_match "brewfile not found", output

    ENV["TERM"] = "xterm"
    require "pty"
    PTY.spawn(bin/"bbrew") do |r, _w, pid|
      r.winsize = [80, 43]
      sleep 7
      Process.kill "TERM", pid
      assert_match "Bold Brew", r.read_nonblock(512)
    end
  end
end