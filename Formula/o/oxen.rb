class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.50.7.tar.gz"
  sha256 "e3949d63ce2ad78937f75693e21834f4b7173fd60684c7835ea43563e96205ed"
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
    sha256 cellar: :any, arm64_tahoe:   "6f49caca46b378bb1074f7ace56133df9f78b6e4354d4d194b221de6f23190f8"
    sha256 cellar: :any, arm64_sequoia: "9ba00641f30735b187d5eed5ec1f185b64f63ac3df0dbff5621956f404b7bce0"
    sha256 cellar: :any, arm64_sonoma:  "6fa2eff5e1f9e6ca6018c0d8ac07a3d05345268244170e0ad305e5779290ef21"
    sha256 cellar: :any, sonoma:        "09713a6d9e3a5681883a7017762cc3ed9f0cc4461aaecb717f4032fa809bba4b"
    sha256 cellar: :any, arm64_linux:   "591dad085eb79f564e3f052c0ea2be584bbea9c289b1f364798f6f3ca8b05f39"
    sha256 cellar: :any, x86_64_linux:  "b6e5c79f3355ca50887ad527d09b2b1c64656e4fa9fb67b47fc1caf1ac0c6d01"
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