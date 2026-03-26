class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.20.tar.gz"
  sha256 "25f850798084e4c01472d90b33f965c237486b363df814bee8cc06f1b38abb8a"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "491e12e422b3bd4cfab09d96f8f1e4cfbec08c5e6ca82d50a222c54a369be5ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e56ef730092dbfd1c153a7009e8601cceccbe9e959e7754e05f62d6cac9528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d00c5130f6e1df6d3fd3d649aa8ba4dc0f1c49171dcd6ad10dffb7dd503ffef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37f4c91618e404e00de7be0f555c4a09d8856c284955212dbb2a6bdb230f8bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3502f6b100bcc224f6aa933b74b353a354b7410259d8c79c3eaffb986523203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "321cc44c7d34939fedd9c7cb483010865bcaf03fb3efb1f87fefa5d6a24e561c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    features = %w[native-tls rattler_config s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end