class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https:github.comjomoimgur-screenshot"
  url "https:github.comjomoimgur-screenshotarchiverefstagsv2.0.0.tar.gz"
  sha256 "1581b3d71e9d6c022362c461aa78ea123b60b519996ed068e25a4ccf5a3409f5"
  license "MIT"
  head "https:github.comjomoimgur-screenshot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "938fd215acee5d33c41263cd86d05eec350574c671df2eb16adf724f522e30c4"
  end

  disable! date: "2023-07-05", because: :repo_archived

  depends_on "bash"
  depends_on "jq"
  depends_on "terminal-notifier"

  uses_from_macos "curl"

  def install
    bin.install "imgur-screenshot"
    bin.install_symlink "imgur-screenshot" => "imgur-screenshot.sh"
  end

  test do
    # Check deps
    args = %w[
      --open false
      --auto-delete 1
    ]
    system bin"imgur-screenshot", *args, test_fixtures("test.jpg")
    system bin"imgur-screenshot.sh", *args, test_fixtures("test.png")
  end
end