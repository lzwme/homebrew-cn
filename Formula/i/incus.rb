class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https:linuxcontainers.orgincus"
  url "https:linuxcontainers.orgdownloadsincusincus-0.5.tar.xz"
  sha256 "43c29ad1bac5c906db0e283c0b879402e24603fc81d1aef4a0e38e660f51a80a"
  license "Apache-2.0"
  head "https:github.comlxcincus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e77bc351433366813bb435a4043099a0680fc4f779326b2fa8aa481067953e36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e99eb549f6931cee9a07ba4c74adeab80139640dc939e19ee7f57022db8baaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0836ec14777b4fa7d13efbf4ef3f104b2a8b2ac35cecb0b35dcade537dd662b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bbb52ce5d4f0d9c22a5dffbacbdf09f22379ab695c35b77c5b32d04ddf3a5f6"
    sha256 cellar: :any_skip_relocation, ventura:        "a96498f85ff0c442e6610eb01b838a6afa5df6f80de6af57f6f4b91ea84c5134"
    sha256 cellar: :any_skip_relocation, monterey:       "ea6e6c69672cf0385c8e7b090c24d25e50c2cd9b84c7eb8f74cb96ee885d3c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338b612625b2f9b57cb92b71ad854097da448f3e92c47f31bd12813cedb9d8e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdincus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}incus remote list --format json"))
    assert_equal "https:images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}incus --version")
  end
end