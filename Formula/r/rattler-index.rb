class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.26.5.tar.gz"
  sha256 "caff81531323f74a1a7a709c168895108505299e57317a10fbea089fdc134469"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da49a9fa79bf86d3c0e1a2576275ec8ae4842eb6d6b26edd04268997748eb42f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25d58be299ff98f02453a6792f8fda18b1c85fe24d3530f27afed86ca606348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70932b69d1b5033bdd2e4eb6abf158aab2236feab7e8c1cb9e249efbbf1dd02f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3bd5ba0868bc2642b8fc36b523b24f9ca88f81ac3474ab6c1fabcc5949555fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c8307f44ecda95d7b9a7bee3bf14e560469bf4219c00876aeb2dcd79efbcc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f170c5e2450a55399309c2c1aa5d34ed912e6dbc9650e76cc090ef9f98e418da"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end