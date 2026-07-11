class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.51.3.tar.gz"
  sha256 "614fc4843674761ca835d526ed87cc8e6729a9975f0160642188e8fd70d4705b"
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
    sha256 cellar: :any, arm64_tahoe:   "cdff60844de42b73c7c171cb18d10dff82c65ac273306b858eca66d2ba462b19"
    sha256 cellar: :any, arm64_sequoia: "46e87cd2baa90634ab30c3ad1e2bc48765dd5148d973ec3434ee6a63c7ca5395"
    sha256 cellar: :any, arm64_sonoma:  "b491bc372c27b1833a0512938a7332c41465c080995a8fa239c874c14f32f4e2"
    sha256 cellar: :any, sonoma:        "66f8d097e1830e6b3332f1739f16bddb4446c12eb5b262780f183357d75a1a33"
    sha256 cellar: :any, arm64_linux:   "cdfd5d355063b56bab90f7f88ab04661d5ae89df85fe8a4aad225aca8489476b"
    sha256 cellar: :any, x86_64_linux:  "54282514b672b3ae1dec342e1960789799689980bdf0545bd467f4fd0457ac1b"
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