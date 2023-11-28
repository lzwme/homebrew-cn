class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.3.tar.xz"
  sha256 "390513be0f7d27568fc5155269be5a40270a8abe19476389e56cb6c43a483ca8"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b67feff388d8a3886363c3485ebfda1f1f3c5be7b2606498f902f1a7293ab9ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b8a7114564cf1bcb8f4f1add260764a6f15a431f45ccb510eccb66686b76556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e922354c1a51f032a58254964e3094329d94f972a0d70d489ae52bbdbede341"
    sha256 cellar: :any_skip_relocation, sonoma:         "59cfd69d9c39bcef94df7d2e15cbf7035fb798248fe9f7585d33458deedba8b6"
    sha256 cellar: :any_skip_relocation, ventura:        "2234f150cda480dfe99e1d9d8f5619efd2b855c6aa52cacd2c6937f342c8bf38"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ab03d8bb4338131c3207d83b5174a1c99f164f8671ff87dbc8f19aa1e314cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7987bef947f8dddbc13180c30ec8d09f9092ffb3dc48ecea1d23693601687cd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end