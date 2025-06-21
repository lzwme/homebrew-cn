class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https:github.comphilocalystinfat"
  url "https:github.comphilocalystinfatarchiverefstagsv2.5.1.tar.gz"
  sha256 "d25397531b436eaf27e9ceb111033a39fa0fe7f74fbb908f6740a0684d5a52f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6466855e24ccda05194b336d748c1d742e1527f7a6fef67b85b59c93f2fa6c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "422b1395feed2b3b4fca3b9b044ba4b3ec6d9109718c1e0cc2a20b27be3a2c26"
    sha256 cellar: :any_skip_relocation, sonoma:        "38ea665b9aa1e64fa4d066a37c51116204ce3eade08cfdd76406346f703c643b"
  end

  depends_on xcode: ["15.2", :build]
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".buildreleaseinfat"

    generate_completions_from_executable(bin"infat", "--generate-completion-script")
  end

  test do
    output = shell_output("#{bin}infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end