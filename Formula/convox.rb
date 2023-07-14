class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.13.1.tar.gz"
  sha256 "ab6646db5d19d502910e7558b6c96b1f26a4cba6a237d1d9291ef62e7e46b40f"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c306cd80c311a380ef107db8745d8bdef44535b447e0cad0b5282161a5b0b84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b11096ae30917ee971d506629fa385c90b7bdb50ea6e9b8cdc64aea20ec1f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95d4adf150d661b1815dfac8b7938d9a8e6622030df322bb2aae0006f2b141f8"
    sha256 cellar: :any_skip_relocation, ventura:        "46ce1147854c706162d30cae30161dbe4482930cb9b3163c54de24ea35af45cc"
    sha256 cellar: :any_skip_relocation, monterey:       "eef3b9257a3f6d90f2e6caaf0f22639a46ceb6d14e7140bf054b6063ef100c96"
    sha256 cellar: :any_skip_relocation, big_sur:        "162aee5bf62b764979abd7c25ecc26a11e67d8870491ad044ba8baeb07f1bdc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a207d2ff24969a856564e538e4b7397ed7b3267a233c6b5f870232ef2cbd239"
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