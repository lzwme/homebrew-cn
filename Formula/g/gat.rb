class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghfast.top/https://github.com/koki-develop/gat/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "d849add0992259baddeb1ff5821c465ff6f2f4626e03d57d7a9ec788e6df93f5"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a3e02471376e45d2623e3c1756042125259e298f3e85b7737adfca496068c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a3e02471376e45d2623e3c1756042125259e298f3e85b7737adfca496068c83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a3e02471376e45d2623e3c1756042125259e298f3e85b7737adfca496068c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "146c7d5619aaef373f4f29a8f5648c18ab4adeaf4295c65c9f8a466ed38ccc7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c88bcceeabe46b8856879d2f565aa8e0bb34d18e9e2fefcfb101007285cb394"
    sha256 cellar: :any,                 x86_64_linux:  "efd1644bfd3d9c80f8fcdabf533d0b5cfc8e7da808f134a5401b35e63ffc0b92"
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