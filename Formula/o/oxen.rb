class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.50.5.tar.gz"
  sha256 "66850f5adaf99f1365d8bd9996a45813ebe3b35c535a1144ee937e04dcc8cb08"
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
    sha256 cellar: :any, arm64_tahoe:   "7a1567115e1dc88dc32b8cd0f9b2a8c6badbcf958c1c1afbee0eea3c00e3b1a5"
    sha256 cellar: :any, arm64_sequoia: "26d71e9673e8a9007d37ba8b4d523cefb817b626c53b4ca918ecb9166889d696"
    sha256 cellar: :any, arm64_sonoma:  "3d0f1d508195d61dee952a9d334d39c28ae268c188b5367edfffb250896e78f7"
    sha256 cellar: :any, sonoma:        "dadcee4d4c4f330606c0cfec32ff4e2d710c9275ae9baba4dc310f6e6e75a051"
    sha256 cellar: :any, arm64_linux:   "a1fb3214bf38bc471012f5a2843b172c0dcab2cd495b332d3a711301110570a9"
    sha256 cellar: :any, x86_64_linux:  "ae8bd3fb0d90f23fd7c6960887a208fbe4ce55fd52cd0c67f70b98ab84ad393b"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["ROCKSDB_LIB_DIR"] = Formula["rocksdb"].opt_lib
    system "cargo", "install", *std_cargo_args(path: "crates/oxen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end