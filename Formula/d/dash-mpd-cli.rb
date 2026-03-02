class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://ghfast.top/https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.31.tar.gz"
  sha256 "25b3f689a899ec2926f3aaa44a6cdd6e7ac22ca304be37e92a4af492396502f8"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7e5ce5092895a70e250727833537afeb98a946313ac89d2eb62256e30ae94c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "657ea55ee75f6d2b2cb19ba0397c8c7e251c8d5f3aed5a6299d69d3edcaa2618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a482c9cfbddd19a465843ed79ee471d339b2a7b3096767a8d57e77467fccfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "43bda6e2da1acebb3336ee5d0189f6a2c7f07345e31b7c51aa2f358a8a6a4442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcf2dda8f1573f8491820b55ef2da78239d5b5d700c5cf46fc56f74ce06b7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb4300b1ee16a004beaf625c765d1c8d3912981d82c35914e2c8303958ee55b"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "bento4"
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "testfile" do
      url "https://storage.googleapis.com/shaka-demo-assets/angel-one-widevine/dash.mpd"
      sha256 "4fb9ea292aba0db94ddfe8c941b8423d98decb51dca851afbc203e409bd487d4"
    end

    dash_manifest_url = resource("testfile").url

    output = shell_output("#{bin}/dash-mpd-cli --simulate --verbose #{dash_manifest_url} 2>&1")
    assert_match "video avc1.4d401f       |  7493 Kbps |   768x576", output.chomp
  end
end