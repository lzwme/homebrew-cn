class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "e4e3119555fc846f3b69e4ca0f0364681840ea91058377f64aec7f98f9f12b34"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c90f638c23b938830a050bbc2b6faa3d9aaf160ef24c4e0039310ae897d7830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c90f638c23b938830a050bbc2b6faa3d9aaf160ef24c4e0039310ae897d7830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c90f638c23b938830a050bbc2b6faa3d9aaf160ef24c4e0039310ae897d7830"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d71d466dce8b39dbf16f64b89a34c2ac77c07c9a0a56489ee4645e0e5352c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6065367cbab1e8ffb423f92141c27e2e24d011b924840932c5d402a6dfd2d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdaf47f1e4065632ce8af7ff634acee78004a8e3060d61adb7fec36d54eef360"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end