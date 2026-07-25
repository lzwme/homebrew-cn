class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.52.4.tar.gz"
  sha256 "5414ae59c214afcddd12c6ee11d0ce66b8e8f0dd00f12bc112a10e69365b0418"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ffa3a7766e2b83a63701e37c0e8daab85d03d7716c25af5f0cb0c06244d3a2b6"
    sha256 cellar: :any, arm64_sequoia: "6fcb88c9ef4ee995a56eb930a9eb0fc5d1053a7c02092260db7ddcbae2f2057c"
    sha256 cellar: :any, arm64_sonoma:  "b01c18215fd97bcbe050a55032a2672abc4cf2064777b9763c75f5ca9ea4936b"
    sha256 cellar: :any, sonoma:        "056342fd64e357cbdc7584f97ac1bde999d1750261deae1b8139e468906e9a68"
    sha256 cellar: :any, arm64_linux:   "ddd5784843611421dc8eec13edda46f7a961ea6a13d5addab40ec024e7668d5d"
    sha256 cellar: :any, x86_64_linux:  "e9e46617a8d9fee449808b8d2d8bf1494216b38d4434e3be6ba13c21f8900e2a"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")
    system "cargo", "install", *std_cargo_args(path: "crates/oxen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end