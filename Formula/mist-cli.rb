class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://ghproxy.com/https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.13.tar.gz"
  sha256 "4fa313fee3bf9455d032cb16eb466a64ef2541976a44da511c25537347488ff6"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5586cd72d100ad23e1410f88c06a40fa867ab3d75ee442de46194cb7638dae68"
    sha256 cellar: :any_skip_relocation, ventura:       "0d090df2366f2db9bf74d14e64fee370f514f9d3926458e82cf1ed506af7a1ca"
  end

  # mist-cli requires Swift 5.8
  depends_on xcode: ["14.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/mist"
  end

  test do
    # basic usage output
    assert_match "-h, --help", shell_output("#{bin}/mist").strip

    # check we can export the output list
    out = testpath/"out.json"
    system bin/"mist", "list", "firmware", "--quiet", "--export=#{out}", "--output-type=json"
    assert_predicate out, :exist?

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end