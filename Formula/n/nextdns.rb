class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https:nextdns.io"
  url "https:github.comnextdnsnextdnsarchiverefstagsv1.43.4.tar.gz"
  sha256 "9166d0bd64ac4c6829f83ab4019fb74ea0e54f5a1ad2b6d432d35c4d39088fd2"
  license "MIT"
  head "https:github.comnextdnsnextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2f9cda0eb8c9cc78a2f79b41f1cc722937ed5212b58fc37c6380a539ad0be22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a2bcf2802c826de5380d69894995e6fda505de22c112e74f0c73cb13594d8c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5b87b9fc750900b990fe61a0c1d0c0461eb6b46960d64bc990b14d317a69d64"
    sha256 cellar: :any_skip_relocation, sonoma:         "676eb5a46c1b87d0292db3538e2e112046b06e50e07efd151c656b22c1d5b21a"
    sha256 cellar: :any_skip_relocation, ventura:        "c5b4bba5c2c3feb6c3275cac9a7bf7d38652b9d97b1102bf673dc30a0ac2ec64"
    sha256 cellar: :any_skip_relocation, monterey:       "474558eb1aad76bfe6df99b9c9e02a60a665ffc870cea72e8b9b9c9b430c5084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110328a17571b9180961ffd0ab3dd5b77d6c31100210225cbe336e5d97985fb0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin"nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output(bin"nextdns start 2>&1", 1)
  end
end