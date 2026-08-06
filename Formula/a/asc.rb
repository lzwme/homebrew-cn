class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.5.1.tar.gz"
  sha256 "c556df19a6090d17f87576ef4d361141c6898ad4c7bab0ebac4e048cc68ece89"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c0f975a938d8827a99e65f57e1bdbb26eab3d1c7daa2bb50f8846703ef2cdfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3fd25bac5017b76e713f70ea5f1c3fa628a8be22a9101dee85e561409d6763c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25c9ca52a712240c69722d1b36af93edb92308b9dd34d13ac772b1faec56b408"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ebee908dda2aada7c5d4b71496fb6aebc80a945af8f12610072d11d26ea26a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d4249facf9becf27ed2df5b34dd8bd4fdb2d2ad393b0272fb21ea9c043d760b"
    sha256 cellar: :any,                 x86_64_linux:  "5604a121affac3bbc875bf798d165c0e215533678e768d8c9fe195ca83f1dcbf"
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