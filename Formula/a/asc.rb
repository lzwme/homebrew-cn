class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.45.2.tar.gz"
  sha256 "4de8faf7665432d4c21ff277dc3dfcbac74a699b9fc456db4858093e09a86e9e"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1490b736e2986c05f2eb94ee4a7650d4c91797db5d79c6cde714edf466f039f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2f8ed553690e76583eef95c7036504f283c4cf2057bdcd45b807d290b3d927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "970f4c295f75c2865718f26173bed031e3850d7ad5f76cafa03b556ca703bc5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e512dc78a348d764595997fa95fb547a41970824e7ae65261a20ae62f1b915b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c2af32ff838254f2627c7c581436f18a05c5f04413d455e9f1f49a45b6a274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a6bb94c1e53eab3a23da2c54f5d35e6c6376d683ba842c6efc2f2b93b7589c"
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