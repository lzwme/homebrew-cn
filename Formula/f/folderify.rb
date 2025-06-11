class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https:github.comlgarronfolderify"
  url "https:github.comlgarronfolderifyarchiverefstagsv4.1.0.tar.gz"
  sha256 "730d19480fcd59b7d5f4b799dc4199351c9442dc80447d7d62bc11fffbb1cb65"
  license "MIT"
  head "https:github.comlgarronfolderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc34b44c1b557fc8135c950b1bae9896f385b0bc70043b08a20127ff179191e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20a12ab6b000c4877828fbdfbe66bcf5dd9631899a606b6af1cf244df0d7cde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d521b6ef4bb8c86350a48bd197fe10bebc94efce5031896878965ba1375fde1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "efbd0ecf65b6b32b59941217457e17ce5fe1e5ff836b7ec822cf37612d57410c"
    sha256 cellar: :any_skip_relocation, ventura:       "36088b0dde07cff745173bf07d843f2368d20015420846d845de8c63d14a8b38"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    (testpath"test.svg").write <<~EOS
      <svg xmlns="http:www.w3.org2000svg" viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" >
      <svg>
    EOS

    # folderify applies the test icon to a folder
    system bin"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_path_exists testpath"Icon\r"
  end
end