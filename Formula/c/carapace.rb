class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b0e0c7d3040d04a71e6c602f4097ffeaf5de2c0e40b5fb8f3b32a1697a94bad2"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7efc5157cb33fd2d98ecd421d18bdb334e8f0ba7e5cea948388dd85a66a02c79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e046801e29a82138a368f24351e712545ee8e9493053e30c2154962e81c52c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b79e7ec3c7303ecbf267a7d48a11bddd4eb39020beb4d3f0f2d75daebd822093"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1557daa399241c45e960ed58c3e2e5c19efab8bdc9d8711f83effe47ea0b0a"
    sha256 cellar: :any_skip_relocation, ventura:       "495c020d42c0d2d9947b2f1d7dbd8141b6e49d043acd93f237b82dd59b60ec03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b4210e220e24a394c185b9fca331f72c9369b631044728e38c940c5c33a485"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end