class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.18.10.tar.gz"
  sha256 "9638c3bf0e31a767e5e702c6f3b86455ce0c281a0e116cb0c3cafb712a2a19f9"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a3d27f4d321a6216d61d8afb712f90ada6d5eae2f0e96698104f1f860d379b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1a992e90348cf9157a7e42249d1725b8fb074efbf9ba68febfbee390e092639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30908fa0cc2733c61208897063f583a8c057cf715e6a57e4ffbe4b23433351b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0efe93d8f57a59ade7b12c46526ce6c12153b4b3427a95cfc64b16646e6421d"
    sha256 cellar: :any_skip_relocation, ventura:        "1d63be71c48fc7b1ed063cba3c9bac1e4e638f2a72ed15392b7bbcd06a5f576b"
    sha256 cellar: :any_skip_relocation, monterey:       "5fb74c88b82c436e3225fb7a8aa6b1caa2d242fa53a11a5889e9bde3b9db926d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a838bd2c3b7c0c36e069a61794e5d91370d21fc69a26e1b5a21d1b76a01f2fe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end