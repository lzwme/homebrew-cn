class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://ghfast.top/https://github.com/noborus/ov/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "87ee2f7d6477b02b5562d0da033e7a8f4f49c92fe7637c47985646c685474984"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2596035fce4b5884d118134e4a00f02d840de1fff586146ab91483b55dc0852e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2596035fce4b5884d118134e4a00f02d840de1fff586146ab91483b55dc0852e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2596035fce4b5884d118134e4a00f02d840de1fff586146ab91483b55dc0852e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0cd2fb3dec2cbd1cb19f467586795d583405730585fc5e738f6632486f9f62f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b4c94c32b3d807209c8e9bd1ae2eca645c55b8e798f2fb911f70d6890c7d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d763f017f988be34d4e57a30094c388ffef927a64702356d50e4050929f6eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", "--completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end