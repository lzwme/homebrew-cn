class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "7768019f0f184201c58bb966947245b37a696b02ee08dbe28ac3e436fcb1259d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ea173cebcf5b44119795d3ff55e39c8803cd4aa421ca1a0b1bc98b1b0923c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1a5174032f564e36deb8db9dfc9810a8d3e5a48d763f9701fd2f65fad5a39a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e8be11fccfed61d7d7287884f7407ed6e5697edee01d8a0a796d7c299d7a69"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2fe3eba4fdede63b333f9ab77abc9040727c6caa60981bbc6900e0021737cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d503f146f5e4a28ebcbd1a33191309dafbd7164d2e5578df623d6703a9321db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75df4be2ef54efdcfc48c19ae47a9dc47f9d71060237951b2cf970697accb557"
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
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end