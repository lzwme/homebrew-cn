class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.12.1.tar.gz"
  sha256 "872122f366793fdbc186af3836052b791733181d0cab6bc4ada7c901269b4d85"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d464c21d70e4ee23c8272d023fd22e40a013fa9f02e0085cefdd17981d21ce58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab07d4ebea84e130b1dd61f16e749ca29ca92b0b0bf6ffae1b2c65910298533"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f37eae2397961feaeabc9b9c65b639da9cc3ec08fb2ba026128e7e79e396779"
    sha256 cellar: :any_skip_relocation, sonoma:         "deb0ddf65010f162869e0cb6837a3cb8fabf85029b723ef7607fc73b156267c2"
    sha256 cellar: :any_skip_relocation, ventura:        "01f223baf4159f445f3545e99764f92da954fbe037b5b10b804894d60079ddbb"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6293a660df3ec4259c4434aa7e380ff875d26fde1392f6f09981abef105e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0218ffccdb78c0be71f299935ad6e40adaec867776a3514e5e67c4e8f7ec360"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end