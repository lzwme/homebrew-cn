class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "342b139f0b76d864b867d4ed5bd1d42d2cf6dfeb8c494ff8fa333df84b67ee20"
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
    sha256 cellar: :any, arm64_tahoe:   "36b3b7553a2ce8d0461d396fa36a62d2c1339546080f49a4806dd715406c4bfb"
    sha256 cellar: :any, arm64_sequoia: "9e0914286d456bfd42a860fa3a2d41b52ea022de716305c3f2a3e3998bbb80b0"
    sha256 cellar: :any, arm64_sonoma:  "1c6b3d832c666410b7ffc1604227894e01a62aabc3c0d77dad4c7f2aeff08a57"
    sha256 cellar: :any, arm64_linux:   "116c8887d67d58c54e3c4e3f371b75013f5aa5080d410008a419c8c9d3a7aed9"
    sha256 cellar: :any, x86_64_linux:  "541e52ea455ddb49e98f1f1ac21655ba766bc907a078d6d54a0d0c53eaaeec4a"
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