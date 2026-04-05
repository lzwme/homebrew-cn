class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/1.0.1.tar.gz"
  sha256 "438ccc377a7bc2105e2322ffc78e401a6f7fe3d8cac2c501d22af5737800e9e5"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b37fd8441455a9ed728898d11938a6fd08450dfbf8dfce484e18d28ad7377b7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b7524b5906a7de563d0aa1db3bcb4d031a4057e5ec05e8168214ca7f10c7740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065e977d507b013fbc2cf6427894763e65aa237edb7cdce1ae7ba5e333cca3ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "44aa4990e3bdfce4fb48a8e044ca25938ec4774b0202bae823626159cd3e38ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc6d675933d0466601f85fcb8449446d70e04235b80c8372a451a7b651ecbe28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7b0debb580e2dde9f0ae6053a669cbffcd918de370dafe1e022c8c3557f2fd9"
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