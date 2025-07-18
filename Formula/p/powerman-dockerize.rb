class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.23.1",
      revision: "67f38473db4017b50603c44fa12f5a0e72dddab3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a0293bcece03af2c4730f956ba99e3ecbac16b858f96aa259a31d2d619f3c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a0293bcece03af2c4730f956ba99e3ecbac16b858f96aa259a31d2d619f3c0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a0293bcece03af2c4730f956ba99e3ecbac16b858f96aa259a31d2d619f3c0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f15a2cdcff5ccb5c2121bb2bd51a02843338cb7fd4bfa3bcce3c9ac50f88e2ce"
    sha256 cellar: :any_skip_relocation, ventura:       "f15a2cdcff5ccb5c2121bb2bd51a02843338cb7fd4bfa3bcce3c9ac50f88e2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b929edf1227ef9345ed11289fdf6dc7b476072bac539513c46d2a0302571f2da"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end