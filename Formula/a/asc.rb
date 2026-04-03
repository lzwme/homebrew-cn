class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.49.1.tar.gz"
  sha256 "a572ab56b4088bc89beee2820afc801ac22758917371e631bb4bcab224d972c1"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aec3bd464fb260c3afee8ebdd9929030058f7c509beed52a8fe115660f8634d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b239803471a73bc0cac9f3ddf43f9517ae6608d59069dc307ffb7cd0f651afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c2ede5bff4e1bfe971110aa52cdc1f95e6685143f38bca092036a75fb849ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "339202130fc7cfe6a9794e9ede0dfc508baf3836d5e57270b16f23f33edfa83b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ffb11bcadd483877001da1e75db57be2a0800e85a8385407a42aa9ca01f626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848e79223bf9c769382e58ab441d46f75414a4c42d3775d478a23db38773f4d7"
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