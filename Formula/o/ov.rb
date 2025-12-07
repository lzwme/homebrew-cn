class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://ghfast.top/https://github.com/noborus/ov/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "86277c652d1568807a61236d1565bbe8b2280be4f11a6075a03cd7581469d355"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eff9324341ccbe5264b6f42b3acc182f3c1a5f04673159a64305705e38b195a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eff9324341ccbe5264b6f42b3acc182f3c1a5f04673159a64305705e38b195a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eff9324341ccbe5264b6f42b3acc182f3c1a5f04673159a64305705e38b195a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa9d5323b28e2fea500878c88e8fc8d9f9635f15f23a100a51410fff6b63e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba1ae53a800339f5e14fc953ff4c31c4a43d8ad272cedbdf745a6baa1893864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2047b24ed6df8ed8804ded0a5d295c257dee1ced6a9dbeb1a172b2841f3d2a"
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