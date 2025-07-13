class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://ghfast.top/https://github.com/powerman/dockerize/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "8cc5e74d6785c6928adacf6fc70fc712b75b0f5bb1dc1e42e27e976acfef1818"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da2232bef02bf8029796b6e9cd47a721dbd3a5add7ef3eca2d8992ad68e13f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da2232bef02bf8029796b6e9cd47a721dbd3a5add7ef3eca2d8992ad68e13f1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da2232bef02bf8029796b6e9cd47a721dbd3a5add7ef3eca2d8992ad68e13f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b25fdf74eb0fc715fd1b0c1c7449429ece0232b291205a050a452d01f07805f2"
    sha256 cellar: :any_skip_relocation, ventura:       "b25fdf74eb0fc715fd1b0c1c7449429ece0232b291205a050a452d01f07805f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d1224444b23fe2cec6d510547ac834a6cc67abb73d37f0a0cd83f9ce42d687"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end