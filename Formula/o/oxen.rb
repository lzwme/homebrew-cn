class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.53.3.tar.gz"
  sha256 "ca7204393e1e0bbc083b6ee61dbfa1ef36c25ab02ab2ac2ab1530ccf5b69ad37"
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
    sha256 cellar: :any, arm64_tahoe:   "b719e4d735241a7033fb53055058f63ca0250449d892f482332ed8ca83859d21"
    sha256 cellar: :any, arm64_sequoia: "3cad7b52d2676c3e05db3de5714f150de5f5468d669a57884cb7d9e84ec8ed1b"
    sha256 cellar: :any, arm64_sonoma:  "c77fb018f65df453745ef85f6eb1dec90a8e5a54a196459f9ba5a2c1e92a0e72"
    sha256 cellar: :any, sonoma:        "63b62c528cdb57d4b68579a9dc4e204e64e5f18c41b262f4960006a233db581e"
    sha256 cellar: :any, arm64_linux:   "b1dc2726b6dcfc822bae12cee2e4d823c057c7a20650f449e02c3d56397d5e7c"
    sha256 cellar: :any, x86_64_linux:  "4450ea82f99a3e3d258370a906a36ed51ae69cf530d5b06b1edacca1fd0094b9"
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