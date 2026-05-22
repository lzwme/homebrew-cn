class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://ghfast.top/https://github.com/vbauerster/getparty/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "ee4ad46942ba7303661a7bc9fde240988c0905a37918755ad658af1261e165be"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "857630e3d6868beced748c41b9f8a666384395141044a7a3082fde68d9fd545b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857630e3d6868beced748c41b9f8a666384395141044a7a3082fde68d9fd545b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857630e3d6868beced748c41b9f8a666384395141044a7a3082fde68d9fd545b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8be1d0c3c9e93085d809147e9d375774d24e8cff99a025263735b968ee2dcb9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe8c016bd379926dfcb3b953e439a0c2613dfb9b758a3ad68092af3b5267473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497f61be26ccf59530272fbf2cb42eb5344e0a6b587b50973545061210c1abe3"
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