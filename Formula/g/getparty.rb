class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://ghfast.top/https://github.com/vbauerster/getparty/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "d2d155cff18e05a431843ce989e14a15281b1ce8acf1d00f9c329c3df0854f50"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46155a52925366b0e92b248d056a7d0793518d7336dba38ecca21081dc738c23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46155a52925366b0e92b248d056a7d0793518d7336dba38ecca21081dc738c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46155a52925366b0e92b248d056a7d0793518d7336dba38ecca21081dc738c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "578a3d91dff37c658e6b873b87a5cb581486db5dd3e9082cfb4c3cdf7e8c254e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c67a02f2c4530453e0b3ea71579112120e20e252d7cf76bb966ca43e8029b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c7dce4c0208431aa33705d19ec8259d4c23c27461f1f5e0d11e11f18e30a6c"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end