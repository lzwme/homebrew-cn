class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://ghfast.top/https://github.com/FiloSottile/age/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "396007bc0bc53de253391493bda1252757ba63af1a19db86cfb60a35cb9d290a"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d0973c816849acd01fbcf90b81d502e0c2134e5c13a6f7976b55173e7d3567e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0973c816849acd01fbcf90b81d502e0c2134e5c13a6f7976b55173e7d3567e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0973c816849acd01fbcf90b81d502e0c2134e5c13a6f7976b55173e7d3567e"
    sha256 cellar: :any_skip_relocation, sonoma:        "03096cce35d10c3f8ece52f62efa7f4651171c74b152a796696079e9f23c56da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd530b9f55d8301bd1126a94505260a88a832e05c807e997f2c25473bc6af8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "871198973767b6b4ca8dfc95202c3d23bf1af8ff0a3868c9830f1558d5991951"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/age"
    system "go", "build", *std_go_args(ldflags:, output: bin/"age-keygen"), "./cmd/age-keygen"

    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test", 0)
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end