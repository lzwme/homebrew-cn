class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.23.tar.gz"
  sha256 "2c04a632d04af89efe688f7c7daff21f7e63b1dcafb627dba060bdbf24f8ed4a"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f26385ed061c039c76b78f3c840427e1738fdde3f3efd8d82dad51cb21c09a67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0915af65d217c6ab4539b68f50e08fd05d8f223248dce63649b4dd3fb205939d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea17066b17955573d25f3ca64292a93fe59293dc5d190f658137b5b981c6affb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ec340cab42eac22598b8c5d36846b0ea1e1a5e0958f4b3f6b3457e7b2477537"
    sha256 cellar: :any_skip_relocation, ventura:        "fbbc3e196ad37fbc61a703cca6160f5f5dc054ade86b7a4f5fced5a53da3cfc1"
    sha256 cellar: :any_skip_relocation, monterey:       "721628d17a4531273d5405da7b5962d8c1d36b889753569a9303758017103b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7baaf3cc23516c7bf4e731a759aeae1576cce5ebbb9f0caa59369bffe2791ded"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end