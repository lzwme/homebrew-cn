class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.12.0.tar.gz"
  sha256 "86c824351fd0768b6683b342ac1eedb3d92e853a4d24d149a780796e01efeccb"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f97a7a226c03e957ad57ee89d4bf9465e605838221718746460f60cf149f4e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf80112ea7c5e71202dedc9831676c11adcaa8cecbb5c7b63a081fc2fcdc522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55761f77013a93c39aa147d211608409bd8f1a9a1a50bb96eb2f39dfed8c31d5"
    sha256 cellar: :any_skip_relocation, ventura:        "29292ca982a5bc0bea9b55d59d79c75b90d08a7a27018b05a6e0610a3b417377"
    sha256 cellar: :any_skip_relocation, monterey:       "a698d0b1071f30cf7a0ad7bfa6cac18ef96e5e1e0a2c8ad8abaa06452c0330c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "01692f309b790b0ebc442e3e13c704b9526fea130b76b1bb7ffe53d8943b1dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48068a339ecc3febadfbd0f098fa7f36b683ee1b7a1c8a9bd118d186d2668676"
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