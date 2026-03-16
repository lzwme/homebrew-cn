class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "2d75ba2622a92eaca67bbafdb1bfdbfbcfdcbc256f9d0a3c06c34ecf53d530ae"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2b17ec200d11cebf9035491313b47b04aa257d2147a508f53f341affe904b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "581aa66843eec55f2d3d44d79df06dc5a5ae2bf1066c034f065b0dd98d1a49b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecc5d36264317bc9278bed2e87e9487dc0765fc81eb0e30624499c7c23edd377"
    sha256 cellar: :any_skip_relocation, sonoma:        "c78b80d6e721291be51bcb6fa069b769b3f2f2422c8f1aac31beb37511895dd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90aa58838b347beabf005d88f5375128371cf46e439c8cb591c6f08151ea6006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f6b57b26ccb35cad5fc6285fafc4d004d8cb2e28b2689b02990c5d311f68b2"
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
      system "cargo", "install", *std_cargo_args(path: "crates/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end