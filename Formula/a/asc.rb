class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.2.1.tar.gz"
  sha256 "e9a8552c0336b24e0d80cdb1b531321e24492bcc9aa4bb0f518326c4e0169dd6"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52fe6cae17b7b142d61478100c1bf508f42acd85a3b62f71ff601df685dda1ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0df934aa4d482e128beaad8be0392326fea5694020a9774c9785602743dae81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b08ba7dabd270f734c3c0529026a8201ccab42fe601bb74e5aef289452e44df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df2c58053da2f3ea6ee28e79e8b3327faa0f943946dbfb1e24e4fce4a7c48c57"
    sha256 cellar: :any,                 x86_64_linux:      "1996bad56118a7530835cdf890665e7ba0a426c8270f72c7aab67b7788596820"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
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