class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https:github.comtenox7ttyplot"
  url "https:github.comtenox7ttyplotarchiverefstags1.6.4.tar.gz"
  sha256 "7f71c61698d07265209088ec0d520ae382b408faf9a61d7b632145607c86bad7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21b35a4928783c686b1977214712c52459efcaf18a0f81dc5f0cb1d9647fd89b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bca9d68b8cb4c4c85f0d9a163cec54acff25b9c1d40de4628ec971770fc6a129"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fef5f8dffdd882312a65c70a7dd9b64054c527fa8d8ad8272026dd8e2385c96"
    sha256 cellar: :any_skip_relocation, sonoma:         "728411e1f09758ff21a5fce5c5c6c6157232890a6274573024e76c75807478ef"
    sha256 cellar: :any_skip_relocation, ventura:        "31a8e5af1a2e722b87c05971938451fa50c5c22347864aede69bbaa62a233bc8"
    sha256 cellar: :any_skip_relocation, monterey:       "044e6cfa84938e03834290ee0aa4e9566a76d3526431066f333f5272e772bb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e452febec6c8f8d475f65f823f96e9000a5589a438b75cac1954654895ef57fe"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}ttyplot -h")
  end
end