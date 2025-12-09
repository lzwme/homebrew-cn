class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.40.3.tar.gz"
  sha256 "ec3e2585eaeebb87df4de46485262965e7192f323f712170e4c7a224faf7375a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c8f5f7cc31bf9588fafacf4d5bb5628980041bbf8403dd1faee39974aeb6034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e80774be189bae60316dc739f4bd4696e81c051728d1eede50ac3bd6a77fa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d3195092876c43557d821c88b390d1acd50158d44caef7bfdeb9d94f85eb3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1132109c749e0046ca044f3ab1b4668aac866845d821f5d1c8e720051e4714a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4bab43555cb10476fe7adcc3cdd3bf77375abc7b560e290536c7cca75e1f0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113c16a6239560a8773a61828ee96a6021bb6134c4b3f4414f095ff5dc3feccf"
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