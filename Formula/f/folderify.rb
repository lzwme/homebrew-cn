class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https:github.comlgarronfolderify"
  url "https:github.comlgarronfolderifyarchiverefstagsv3.2.0.tar.gz"
  sha256 "a720edf253dd3179c124a50cb3fc28ed2f264152dd888427f9cc5832fec1b812"
  license "MIT"
  head "https:github.comlgarronfolderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001ffa98583ad58be5bb7b30ac1b6d1f874a30fe65dc9043b8c5a95661efadf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f3d37bd489ec60fab46d83e9d5dcfa347ce91b8f82efd472ff866984a5cfb1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94a9db29a8eae190fb75a709526f1e6d6c8503f51fcaf5fed0847e127f4a08a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d81fa8acaa33ce3f9bcf88dbd161a602887b0e4bfed308a152165e8424c6e0d"
    sha256 cellar: :any_skip_relocation, ventura:        "3a254c2a8e9816561b7a686694d843c9dd9cd033f4a55125f464799609a648d3"
    sha256 cellar: :any_skip_relocation, monterey:       "db46ad2a2080b1c573a853d74c92c5a1c8260bbe626c54b7357ec7a746d4b130"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http:www.w3.org2000svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" ><svg>')

    # folderify applies the test icon to a folder
    system bin"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath  "Icon\r", :exist?
  end
end