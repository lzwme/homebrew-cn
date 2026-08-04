class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://ghfast.top/https://github.com/vbauerster/getparty/archive/refs/tags/v1.26.5.tar.gz"
  sha256 "b18b4e3f19f5f0c50f02f01cbeef8dfbc8138d0a1bb32ff716d8e6db5aed6b6a"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ab6df4e5aac964ef3d74e25160e258442a0029ef7dbe3922da80a956d34517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ab6df4e5aac964ef3d74e25160e258442a0029ef7dbe3922da80a956d34517"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ab6df4e5aac964ef3d74e25160e258442a0029ef7dbe3922da80a956d34517"
    sha256 cellar: :any_skip_relocation, sonoma:        "abcf9686d3aa7a66c0472f3c1110b73cf289a1b0906f25e017bfaa0b72acf0e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5a3cf011c9e680de191d0af1460ad86b330fb03c4ce5c08c621be259fb7cc8"
    sha256 cellar: :any,                 x86_64_linux:  "6b10f02e6a7662c4da36c45af565f3e8e568a08dde0f63e322490b914fbca7aa"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
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