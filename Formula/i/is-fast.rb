class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https:github.comMagic-JDis-fast"
  url "https:github.comMagic-JDis-fastarchiverefstagsv0.15.14.tar.gz"
  sha256 "9125f1099899a9eadd7c74ce489cbf0e213e03fcf786906b6307eb7c7272f0ce"
  license "MIT"
  head "https:github.comMagic-JDis-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d32cff395d031d17203722c88b758c76c8a03b1ae0fd2e26ef1cb369e548b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f2a50c80b9bc5c2281643f2b6242db417fde13e538585e3d838c7618b6e18e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d7dee955bf68578f8b6b39ee0449a8ee705f408f50aa97d369e90f871e2a3f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "698950b101e4fa69df26c157e76431f278381d06b8626bc05d8c4df06181f7a1"
    sha256 cellar: :any_skip_relocation, ventura:       "81abefaa42295fed73cb47c2ec1b189a811759406032e927ee7caf045a08788f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "991eec1560b41e1155839473cabae831682686654030df0af268f615cea4b405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c693e93632b0b92606ef0dc73f63e55805a22f4c7e9f1bf3708600f69390816d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "is-fast #{version}", shell_output("#{bin}is-fast --version")

    (testpath"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head><title>Test HTML page<title><head>
        <body>
          <p>Hello Homebrew!<p>
        <body>
      <html>
    HTML

    assert_match "Hello Homebrew!", shell_output("#{bin}is-fast --piped --file #{testpath}test.html")
  end
end