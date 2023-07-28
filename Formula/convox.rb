class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.13.2.tar.gz"
  sha256 "e574a5249f720135f9511edba6d9a5590b7c4e20dbc63625db7a610a2ac233e8"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c459dd4a4d4b5318b0575da7a76acebf010c0d686ee38842b48de4781358f665"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dee2d280cb00e566c2f996f56ae88e5630f3bd3bf1b37c11b33414c11f30d97b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa168aa8e3187729125fae1b5942e0f5ebf269deea8e17c09880bc5f4d55ed5d"
    sha256 cellar: :any_skip_relocation, ventura:        "9aac94fee41883d6d94fb356f3098ebffd00f363750c43859f25693572d47794"
    sha256 cellar: :any_skip_relocation, monterey:       "13cb2c70c24ad7e431a8280ebc87ea623728f1e70ad3a7049769d1d458b5fcf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c64fb472634677b0680e890d23b1b07df3989321e284f46b780bbac49d9f313d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff3b670a8c07edae1e27c229b44273de2f91afe342727883dad8a3ab1f7b0f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end