class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.41.tar.gz"
  sha256 "212a1c81a99fbf86a55f0f74722abdd76695a6602cb22a842478a5e66464704d"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d50a98d69bdf76a0abeb028b9cc0f057b591a2773cc50c60e72f3f2683e7b8f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d50a98d69bdf76a0abeb028b9cc0f057b591a2773cc50c60e72f3f2683e7b8f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d50a98d69bdf76a0abeb028b9cc0f057b591a2773cc50c60e72f3f2683e7b8f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3958a93ef4046459ea8f5f6f2bc1e10aa6665fd82b953612f85f8877cd6ff9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24aa0a9fd1d052eaea241ff4cfa4625bd7b153f360f829a03cda63cf6dd62a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "949e3dd41506cc973600c2e8885837cdfe1f449e4cd38c9efa5b78cfdbff7aee"
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