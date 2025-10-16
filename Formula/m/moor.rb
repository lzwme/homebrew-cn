class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "99f4610298e015aeb98de3521d724e840efb24f2e7514fae1d6a8ce8f7ed7c0b"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b82c06f771c38a1b3f39d9f31eca15a2187d51c8682915611b82024a7502fa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b82c06f771c38a1b3f39d9f31eca15a2187d51c8682915611b82024a7502fa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b82c06f771c38a1b3f39d9f31eca15a2187d51c8682915611b82024a7502fa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3078bf5d5add1fd6f30ac6004f67aafe5d86cdc9a2b54478dc2b9e9aefa6b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ea35c6f99de3ff3c913b76b71be9a51df607055bd8451b76641b5144fb6fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2abf24387d33debd945fb68733f9e3ab353ed7730ab30f6e2aee9d1eaa4af3d"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end