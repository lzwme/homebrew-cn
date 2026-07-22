class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "ae7416a949106c8ff3298dfb6d11cddd957cc67eba42610f96d5042fef0da9a6"
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
    sha256 cellar: :any, arm64_tahoe:   "095f3af12194e4ed24e060a8c481ca08c779cf888a5cfe8e594a8616ea938f9e"
    sha256 cellar: :any, arm64_sequoia: "3ead7de44393bd278a54622a23a867500248eb3af8f470da31800ca560ac9749"
    sha256 cellar: :any, arm64_sonoma:  "d2913cb175a684dc2897c73269686c0878d6b592a4730df2ec12fe45f9ddd25e"
    sha256 cellar: :any, sonoma:        "07a45883464689aadb04ac3ba884be1bf3a2409d8e16d3e943f664c0b6541297"
    sha256 cellar: :any, arm64_linux:   "aadd4e1f3e8ad219b0f8f02d49fc10758ab89bf30148f90bfa6a1399ec26c314"
    sha256 cellar: :any, x86_64_linux:  "29db06f487b816a9952eaeb70a7045198f3e6cd7799ecec231b6b473a2136c89"
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