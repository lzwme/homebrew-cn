class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.41.3.tar.gz"
  sha256 "0c8a2d12cbf938c993b4ea6e40f98984f924c3f8208ced4421bf24af09c6bf63"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45cd29334ccd3c46f2e476d41c137732fec5b0a0b1828ff17f6509f5ac8d96d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac22e8c2d7415f8b1bf35116ab8eca8e41ae80fdd6880e447cc78837afa5c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f78b128dce9408e23a00b04cefa4f377de56f03843434037174e11b633ca87a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "359137283005ed7069dc07e9d895e70c49397234200bff9f7b2b36a237fabc6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a2f51b64a369d1214680ed390bd19c7edcbfdd0f5b5985a58dc1570ccd755e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d0c36969cb94bdb6722ef583eac6f86aadd0bd55f048a003a331de90e3e00d"
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