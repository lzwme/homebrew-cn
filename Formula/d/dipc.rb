class Dipc < Formula
  desc "Convert your favorite images/wallpapers with your favorite color palettes/themes"
  homepage "https://github.com/doprz/dipc"
  url "https://ghfast.top/https://github.com/doprz/dipc/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f94d5f1ace68427ada4b59179f75d56ac37b9783fce855a1366aad020286c4af"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88d30506314058775963d4d255abf0f08737d57969b1dce9279852d74a8933bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6395f2a1d07b7599b9b133bf8f113ab2b4654750b6edbbb38ebc0f736693648d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b721161cd463f3126eca3f7dd01a132bd443c5ccabbaa7e56a6e3a9e1c7b8e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "49ade9f99f5e6fe0f855e021a97334d06bfbce43e221785549d154b29969c377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd97c70579f1666661ea9e212b02a4500581e8f1870e07e435913638cc325603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7f8cb570274106ad647078b00f9c49bb48d6411a5598aebb602ec4630f33e19"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test processing with a built-in theme (gruvbox)
    output_path = testpath/"output.png"
    system bin/"dipc", "gruvbox", "--styles", "Dark mode", "-o", output_path, test_fixtures("test.png")

    assert_path_exists output_path
    assert_operator output_path.size, :>, 0

    assert_match version.to_s, shell_output("#{bin}/dipc --version")
  end
end