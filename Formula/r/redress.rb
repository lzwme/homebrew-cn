class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.36.tar.gz"
  sha256 "95c85f7ca3660dcbc0b3807d79f2043f02828a3f8950d11d876da7ba07974667"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd1392bd79de27f5afe3591296f101b139c930059dcea64198347e2d605b305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd1392bd79de27f5afe3591296f101b139c930059dcea64198347e2d605b305"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebd1392bd79de27f5afe3591296f101b139c930059dcea64198347e2d605b305"
    sha256 cellar: :any_skip_relocation, sonoma:        "a19c537d0b95076ac598f331c6ce290725b7bf7f0db0ce97ba86bf5711a41e0f"
    sha256 cellar: :any_skip_relocation, ventura:       "a19c537d0b95076ac598f331c6ce290725b7bf7f0db0ce97ba86bf5711a41e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d485188c3c01f65b0a147ecdf9a38fb75e271d9a5e1c629f3b6e3a753ecfcf0"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end