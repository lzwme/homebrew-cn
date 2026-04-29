class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghfast.top/https://github.com/koki-develop/gat/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "44b9c6c61680f51041c354de41b2a9f184a5043072774a832425fe1ba69e1891"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc7f104bda4e429b734b27779dd37f888ae2c7a266de3dc395c15951f46550ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7f104bda4e429b734b27779dd37f888ae2c7a266de3dc395c15951f46550ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7f104bda4e429b734b27779dd37f888ae2c7a266de3dc395c15951f46550ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "b622234fd637215774db0724aab24656f3fbd3cdf0f115439eaec8b15c3807b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f751f63ea23f76014204c540624e5f04658e8519ea32b078b8dbf58ba939e223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64cf91fbd1595d9592d9a00773e862efecd9939a19e6c479038ca5a91abd633a"
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