class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.5.4.tar.gz"
  sha256 "af408ed4a4f3f792caf189b091e13aa792b67b8b902ba3a4b8f02e3c735d31a4"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99f8e7ee2cd05971da9fad011531941c31b58c9fccd6777933461984f8ebfe7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dbb4330beaadc89de9144272fcb40f021da4518d8a609928670ee491ae7d8b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a91f4022d3dbc13e79ac3eb24004188aa584d60e04c18859b1e97525ca150d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdde109b3dcdc32d856b91bf669242a2e091f408485ddf11fe8e62288f14c127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b9eee746ce9299666b5856b005af7352d367c8ae8290a699376812b98f422e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8baccf5174a4c36c9acb4fcd2be9452a60c095acff08baccca09f8cdc05c790"
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