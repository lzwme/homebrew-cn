class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "352f9da1b943cf2f38f61b6dc3176e9dfb97c0a7f58e5f04dc250c0ababa96d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47598e23ba8d0c6df429375b0e1cec91c816d61202e53fe88ec91942127f5ef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ad2a83b587d82e982ee1dc39dda9924c9f50fa1b67c592d495addddd0b448e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb963fddac8f5344b3e898a4df9188cd2f08b4aa386a49f7b56b55227358799"
    sha256 cellar: :any_skip_relocation, sonoma:        "51c1ec4331dfcec4a8166f73f63ccc5d8309d43a617a4ecca5b9389c0e1d5cc5"
    sha256 cellar: :any,                 arm64_linux:   "106bcc17eaa486e24cbc1077a1ba8037888dcc4219ea52abb30bb73023a7c53f"
    sha256 cellar: :any,                 x86_64_linux:  "44ed8edea42e6f15d7e8c3d878998e77bac8421fc161d102fbe19d86155ba641"
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