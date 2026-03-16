class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.43.0.tar.gz"
  sha256 "981190ec745fba4c477e8c4f87316f6a282547b6145b1e9983ded5e985a2c67c"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaebe137fa85f2e58c5578a97db9a4c549e2b9e341284a3602e5aec5359d21b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7f8597a2f6be653cdb38629455791ab42ea0a300f199e895f6c40c8f08abd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "104716593eecc145d4f66c5fd6c224142434264ada1d640efa1950400c0b48ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b50c1ff24ab477bdcd1d5365cdd5789ea2a9ec1669a4b6a03a7f498ee4c23e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3bdb9790717c6b88e5f1c2d476067a1447d124bd12145100581c72101e8457c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "152edfd5a1857528fb86d67b8b9092aa525c5d01549104fbdcb6b4c813495760"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end