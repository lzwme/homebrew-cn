class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.7.tar.gz"
  sha256 "092ce46562b9f55e6913b79f36ee42e865b8e8e9c9a3a83db6e3b8121b753cd6"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "696fb0c5ad9a0a589e0af6bba99084c9fc2768cc89f943846cc8561ba5808a30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3dc8e238594cad0c5ecb32eb4e701696d5579acfc6206b2911105d6f51409c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6bf2038e42d23a7a81fa97a800d16102e41a920748b042887837a19af6edb8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "abf5574f8c81a1fc05482e9d75dd4c16c5e835e3dbdc91e9e5cdb7d2856f458a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e19aea3daa910d9f056e952392998cb8dd5a1f24a0e3473f7818f9f91283b8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6e3021bae8744ff38a5b4ad0d0647255a347d9edf1792bfda291a891a37dfd"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end