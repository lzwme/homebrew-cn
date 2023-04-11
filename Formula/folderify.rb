class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://ghproxy.com/https://github.com/lgarron/folderify/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "38bb7d6b0dd9ac62f8338d9b6165c6222d948794809f50dc7a34d727d2c0ad9b"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "506bdbcb3dbc5d7971dc7f6f870eaabb8c3f35e87605694936c91b275bd3ab5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ee59515db58c269c60dfe3e0f5bf2992b9adf6c3c035e7c990fbdebcd91d323"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b223dd2acdcc1b6ab15f943f7b9b53834ffeaa707ead81c4cb53472e11ff606"
    sha256 cellar: :any_skip_relocation, ventura:        "3344ed2ade4e9e876f2a3fdde3e03ad38894749518444feac00bfc6ca49b1345"
    sha256 cellar: :any_skip_relocation, monterey:       "eb19a632c521cd10d13e97189f7fe81842d4d606dc02ac7165deb63a0a4afc5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9e270216a91feaae25fd721521939f2f4caddcc9291021a2606a7145e2031f3"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" /></svg>')

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end