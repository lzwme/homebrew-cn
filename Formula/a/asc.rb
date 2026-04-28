class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.2.7.tar.gz"
  sha256 "23b644f12ba25a7e2f92fc86c797f88210652590abbd4cc3f38086e235847933"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a350ffa1473ae54482ba33c9ad41eb92824bf8a6b734071659dc419ecebfc357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73770e872dd94801da9fc7f7f9d2b3b9053742463ac8b3f3dd8030decfd4be47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f39b98527a6c345de0e9847477bc955915ee5dcedf8c14638a45f675d27778a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "767e1294fd6d16c56c3f1a74e2978b997a2af22957f115caa059c29151fff46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde126c90b2529123b0a6d7ec6b7fe900c476564e8ace878719f185550f9eb59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ccadddfe0181272517c72632b1b20444faf6386e881d673cfdb1311faac0452"
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