class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.51.5.tar.gz"
  sha256 "4b736e5f0596349af027a9759b18d0645ff858dca403f9163b11c40a521ab357"
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
    sha256 cellar: :any, arm64_tahoe:   "d4932960407750da448a332e5b34fbe7b7f8d51e41ae31d8fc428a8186042a62"
    sha256 cellar: :any, arm64_sequoia: "c4baec7f599de778b944b299239a84e63889904e3fdff93c17f7f360ed829bda"
    sha256 cellar: :any, arm64_sonoma:  "54e16a91fb70a32ec02e52e090902727cd736c0ce8e121beb29c576c706de753"
    sha256 cellar: :any, sonoma:        "a308ec68c0d90d7bdfa2dc54bcde1800689da9406eae303b0b01ac23b0f7de99"
    sha256 cellar: :any, arm64_linux:   "d42668c13945376cb641d5a901fe87bb739aecf12aa08363c1ff7b0db9c244a5"
    sha256 cellar: :any, x86_64_linux:  "73baef3e291875621059af722eddeef908e91a777df4b2b2f58295dae4162f87"
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