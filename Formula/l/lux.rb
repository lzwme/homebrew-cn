class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https:github.comiawia002lux"
  url "https:github.comiawia002luxarchiverefstagsv0.24.1.tar.gz"
  sha256 "69d4fe58c588cc6957b8682795210cd8154170ac51af83520c6b1334901c6d3d"
  license "MIT"
  head "https:github.comiawia002lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5af366f0e1b73c4926287c7227d026463ae47f383efa10eeeb01faa2ff7a21cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc8cb18111ffbfb8881a1ae0e4973ddbc201f1cf300a5c0d6d7488de52d7386"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f408349e07874ca92110e3a97811c3538a4336c4fa981b4eab2678116b693b51"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4bfaaa7742a309ccc67eecc73a79baca0c7ee41aa64e3b3ce8353dec459ce11"
    sha256 cellar: :any_skip_relocation, ventura:        "ad62801390bbdffaf44fddf9bdb162d82c66b34a7315fbdbb96e59e2520d836a"
    sha256 cellar: :any_skip_relocation, monterey:       "cc647637d6184e61711b886d5f9e6edda5a8a9c36c224a2dd9ea2e6cf7d8ee3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8969910db9f1affb496df289b867c1353558dc20a2bca291f604a6628edc62da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin"lux", "-i", "https:upload.wikimedia.orgwikipediacommonscc2GitHub_Invertocat_Logo.svg"
  end
end