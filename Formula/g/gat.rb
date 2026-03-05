class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghfast.top/https://github.com/koki-develop/gat/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "ad4388fad1c3358318f39f0e56af52174d02249f55ee30e2191022adfe06e56c"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7acfd51bd042826421784ec9f4518be16e5a70317d0c845c89df497952b1c834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7acfd51bd042826421784ec9f4518be16e5a70317d0c845c89df497952b1c834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7acfd51bd042826421784ec9f4518be16e5a70317d0c845c89df497952b1c834"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe8fcc28e511f3ef2413c052c6878de38cd5cbcadbf4a31f48c990d0aeb83d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7947e292932f96954c04bd2804fd4956c16926d5ea11d6ae4abaa58100e85596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce9b3bd9b942172b239e4a53622a7d6084354fac00845d4d23bd0ed0e70bc1b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end