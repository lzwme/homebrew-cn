class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://ghfast.top/https://github.com/vbauerster/getparty/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "237c95677d1f9db84aecabe808bcfae91747ec87ae92bed869e18f2488003ff8"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74d03f1c661827d548d565b6d1c489e7d238b095b3803cf70da9ff26d8e6f980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74d03f1c661827d548d565b6d1c489e7d238b095b3803cf70da9ff26d8e6f980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74d03f1c661827d548d565b6d1c489e7d238b095b3803cf70da9ff26d8e6f980"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e20aec87711bce7f52d2b090729d72ae287b7bd1865976b6dac6e0aff4598b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a92b10dc1262df66d7a302aba7048582af766612b78edefbae450a5de0e3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5a92bb9cf6ef89fd4d34a76abab07861e74e96a666e88fa4fa0d8669d064fe1"
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