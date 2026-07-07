class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.6.0.tar.gz"
  sha256 "ca0ca69eb1c2a782fb2ab77268025658fdf97238fa1e308c7ca56c49f15688cb"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9afab05d7238a4f76f4fd2f6878de9370cad0c8e0232b6ad96ca9a6f45a637c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18710d87daeccb30d1354f413a3e714e28aa1665ef0fa4d213445e38dad02041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d183ee66a369a60c7ec5d2d77fc903e490065dc68f518e7c51ff991905ef9286"
    sha256 cellar: :any_skip_relocation, sonoma:        "73cded6d9b5557c37a82b868217a50171b6c76ae1004af1965f26551d9a296bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1b72bdefb32533e98c9424568de61d0ef53668f78225ba036e39e079cf7b46"
    sha256 cellar: :any,                 x86_64_linux:  "019402760e2c89370dbd26f6d17ca9981e4da1a20834e78a67c33bf7ee28a234"
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