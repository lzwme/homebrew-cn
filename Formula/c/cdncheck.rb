class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.36.tar.gz"
  sha256 "2c5bb9a40dd3c9d18d5d7e4893a73303e98ec073c9306115132fc177ff9a77e9"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34d302b6956d2e5159485a3012b9afda9219ef67b020946026b5defe0ac83cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc958647317b3c4c4f04032914144c84551d8e2c95dccd9114c20bae6aeaa48d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9c3d72f3f7a8be4a198611441f980686652881adf16f25e257adaf2a45089d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ba6ca2c07518021a74710380695085d25434430f4d01e690cafea7a2867e6e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75bb7e94cf3758b280e516d9f33e740dd440b8a0e8fda533c5b3789a4e53e2d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c7368287c0c7e35443b7d5ef8807057435879bf39036db7a762a839467f60ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end