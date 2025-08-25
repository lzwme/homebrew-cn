class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://ghfast.top/https://github.com/houseabsolute/ubi/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "5c615c73d6dcd027cf707dc7b567410ce568ca6f67f2a01aea4d51cbd0bd6356"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89c713623bc07c102c7cc807ca3bd6b320318cfd466d307d990cca3a9a567a1a"
    sha256 cellar: :any,                 arm64_sonoma:  "e440a1d9483f82e11b91dca4fd6a6f79c72940821b2d05685db9940f88293450"
    sha256 cellar: :any,                 arm64_ventura: "8fc68bb5f66bbaccd0be5516334768875f6c83cb8cb3aeb99e9c2fca5cd918c6"
    sha256 cellar: :any,                 sonoma:        "81df76bbca990b370465881e61c78f22bd4cc4529f3aebe0c035c05fbecca6c0"
    sha256 cellar: :any,                 ventura:       "cab4e0f187202cee9f7c4b3d7575365fbf7c90efcc75abdd375055e6ea6a8efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f048d2662f580e467955e0312da56c2fdfd76cb926707cfca1b27d4fef997e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3caf11a1af31cc54d684ae4e85bf2c1c3c8eabfbd5ba19af1fc97f5789550c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end