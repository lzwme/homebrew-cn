class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghfast.top/https://github.com/koki-develop/gat/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "a61f4956dac1bb52ed3a6aab571ac829f4728bcb66bfae95a64741b893bb24c2"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51613e969d1c13520996ebb7e207f50894551f45fbd71a01b9830e2c1bb0adbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51613e969d1c13520996ebb7e207f50894551f45fbd71a01b9830e2c1bb0adbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51613e969d1c13520996ebb7e207f50894551f45fbd71a01b9830e2c1bb0adbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea00aa6c20457e1a7f3e1d9bf0c53e89e0d09a299a85cf7a6e2a270efc0588f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39b6ae59377d6bc2cfd8492aee581810fc17192daeb7ad82608cdd570b11232a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2861b77cfb1d84dc0b91651fecc72d6f1b17f2680795965f06d3f3c5e40d8184"
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