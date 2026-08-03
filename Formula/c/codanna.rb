class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "210db22441d86d3f10a13cd4d5dc5c581db92eb7c4a09576f04eaeff5bd84a7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee61e6b2c71375ed651641d6970119b93888b9ca630f7470287fabf3cf740ab5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01a6454c9042bc72e37a121dacd9357037c0197f788611f456d069df82c7eb5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "886e3b19602ce7bfa8fdccbd9334e5c6f7301a382d30bc094b4e0da85cb4c4c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77d2aaacf8c007b889756f649bfc6b373a38371f73e1beb6f9f8824c4ca129d"
    sha256 cellar: :any,                 arm64_linux:   "02d993568699fd9bfb0ef0f03081f4fcf0f5c4952d050043a634401d4f00f019"
    sha256 cellar: :any,                 x86_64_linux:  "38e170beed4aa138a7ceb3b2de2cf3bc3895546430edbd22421707871c4a3f4b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end