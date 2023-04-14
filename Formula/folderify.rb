class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://ghproxy.com/https://github.com/lgarron/folderify/archive/refs/tags/v3.0.10.tar.gz"
  sha256 "e8eec13e392ca67f78af2809425590afb30db98edaeee36f8809a8541d669be6"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2f69828fb1cf8b499dec246762595be3f38c62707202b0b0a0a9dc4354b2564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bac1f33acb7a2bf9246b27d82f1820b0435dc39be9c4ff3515362dbb588445d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5a50cf663f047bb2068560e7ebe7f22fe2e3247311b950ac6c2008ae6f1f2ac"
    sha256 cellar: :any_skip_relocation, ventura:        "ae51da9b4d712ee464acac72528f5706d86caeeca1ae81684dee3977ef8a91f0"
    sha256 cellar: :any_skip_relocation, monterey:       "091993f2467dd627d887544653fe16ee4c759c15586b47a7d61809cd684332f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a160db1ca50b625a7cd32ec38686564ae5423ac6e2b00e28193eb032ec7a36ad"
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