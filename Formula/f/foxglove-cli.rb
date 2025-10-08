class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://ghfast.top/https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.27.tar.gz"
  sha256 "361b39aca2fb763de14a3898ea063fcac2dbff0077344526c6183dbb78f47bd7"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08306bf07c25aa06112bc24c68e5719b14fd37c168ad5fa6d36a0eeede955522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ef4ecbf1a5a82ef06eb62ac6fa22b57a9a40ad2a4eb2df7b503d547212830b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc8bad3a3c7f861a2aff2bc68c97517c804a877aec09ed2ae7d3098db88312b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cba2ff50095bc5a764d326f2ba0ec8fe682464e9f0b4cc4870267f8339991246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa283ad647928adf844e537617438d8afdaebf790f505bf3c61e6322524ad9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975827cd02846278a65aa05d3d87cd273f93bbc6b36a72a74d5357139b897b6b"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end