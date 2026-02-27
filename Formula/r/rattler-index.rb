class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.16.tar.gz"
  sha256 "6fce69b0135102e821014dc806153efdcec3be0c435d26220a747964ac509f26"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4edd893e982cd1c3e7dc6e15733fd73ed481c0780aaf404a0de04dd06b870bd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4baf42cfa69d21fa4815a5c96f7ca8eea1f8704cc4eee0e0838f59637a480174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "927481ddedde17e6b0cab9c18c054aad4037fb85e969468aff9529eb2a3e7128"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0bcee96a8e1c5a4e9a04289a484c3628045d1e32aa1de8328921689bb82e5ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c49a522af7847bf01707fdd90969f1d59a3435f35ee365caf7b984b597f3501a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaa67a09428c31470246794d8eb7b945c4fd8726f13bd1581bc70ea538a54761"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    features = ["native-tls", "rattler_config"]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end