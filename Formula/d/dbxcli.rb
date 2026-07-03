class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://ghfast.top/https://github.com/dropbox/dbxcli/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "49d80ff75f879420ae0e20bd77172a1435edd7e15bf3068cfbe5696d89a8c43b"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c78662eb3c07f3e709b57604541f2f66ff721d949e9a6fb22b03e6a93cb9517f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78662eb3c07f3e709b57604541f2f66ff721d949e9a6fb22b03e6a93cb9517f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78662eb3c07f3e709b57604541f2f66ff721d949e9a6fb22b03e6a93cb9517f"
    sha256 cellar: :any_skip_relocation, sonoma:        "563f01696705c6d83bb7ca9f16a0c9225809e6d0a8efb6c848b21510146e2d51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170c3c1e34350e79c5350ef5b77efd2dff9d151d56b15befc3c5c6a7489d6617"
    sha256 cellar: :any,                 x86_64_linux:  "e0c60d920a22e05fd9f01ddddc91e29c7f4ec59c8c4745441acfbdbafdca0365"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 2)
    assert_match "no saved Dropbox credentials", output
  end
end