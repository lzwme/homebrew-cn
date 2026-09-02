class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "bbde1b3e6456ef4342550ba94540992457e5141c5dcec4c44a8c838748b6fd69"
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
    sha256 cellar: :any, arm64_tahoe:   "6488c3fa5476bcd4dd0d43eac76e840cc798519a28fbfa2dc0dc4c65d5e60450"
    sha256 cellar: :any, arm64_sequoia: "8eabc0647a85e66db0f4320a39c95f7a384edc2162c856c850b49f92c525f3e1"
    sha256 cellar: :any, arm64_sonoma:  "4f8b724c6e364df536e4ad4cd2af77f3cc4957785e25a0564fab0a147a629655"
    sha256 cellar: :any, arm64_linux:   "28e54cbb77876ae52785146d436e0b92dd02f7a23b2cd90160e55aaa6b421826"
    sha256 cellar: :any, x86_64_linux:  "fb230de51ad772f2b2897fa740a0322fbdfec87cefeb63d8e6cce550f72dfe01"
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