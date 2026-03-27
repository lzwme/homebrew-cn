class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.46.2.tar.gz"
  sha256 "1fb3641ea68d512182dab0ecbd44ee4c6877e3472d52c559ea7b1a3af17ae180"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b1ce544d4b57a0ac39db492038474ab00679702a5dd5f66163d697dc6563d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b18d26c607f986c4c0f8cea8b152f78b3af26d157f91a58d8bbea173515fcd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d5f8e101f6d20bfa5d5e9edbfb85e8824f0bc9123ed16a63bb50f1aacafcd87"
    sha256 cellar: :any_skip_relocation, sonoma:        "affb9dbbc6501ac9106baab55da34e7366c38c428e983926d9e31e8b06e3fa66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b147a615cbf87b5e0cd6f65e3d8301e844ac61e72a5dec3be5f75a92a78331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be4593a2e3c8dd844afbb1224cb1fd1ca6160ae6b162dc29c4e6165a7a01b89"
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