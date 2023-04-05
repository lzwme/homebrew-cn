class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://ghproxy.com/https://github.com/lgarron/folderify/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "ef35c574533b2cdf3a6427c2c3610614a59048f2936295d2323a8fecf5852e43"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56fcb79eb80e762364270f237bd43c80704f7a3c5334a96d8a55693e56cad5bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a712442c599ee275dc77fb1a9e852baacd358a5ea932304ef9da6b7ae8b8652"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a527edaf52ca1474e0490db9a3ba2c1aa5f896ad76e4b1d86dd061244f053b7c"
    sha256 cellar: :any_skip_relocation, ventura:        "876498f71f8882ea64664cc337de821fe8ee81023bdb493f04eadec6bc137547"
    sha256 cellar: :any_skip_relocation, monterey:       "a1ddcf8aaf2eeb3119b5e21ffb9a87f8ad76d7371cc24c401b47f2c8b531b65f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bef42c8b34680436a2313eebfd84f03816c50eca3939baee7918efb0baaf0bf"
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