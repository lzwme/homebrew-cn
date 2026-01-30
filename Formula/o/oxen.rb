class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "7852f35b44dd2684218e820693bc567cc3610239640bfbb73d8fd973294a5617"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27dc4263f9ab0844de3a1bf3e28452beae2e0319d7a4d9e139651c40063e1cbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9756c3bc64c3e4b6b189ac3079de2be5fe4e200c1706ae1591423a729dd9e19c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c1e03481170b988af32176913a7a65b30ecbcc372814efd311f2f2ddf631ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e461b28b2bfdc72e31aed27f0f4f079c1402a6ef2af388b2d708f49dbd9ebe35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9918a89c47dd207f2f9d90fa8bc384080f163a499bdfcb2e6c8544470d40a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ede42c9a70412461bfc8fafdb5a7d3c6457957b24daeb7f570d846d9b9b256e"
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