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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7425788ed27fb9eb459f0afd7f9d28430b569265653c5de3ccff908c2f51ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e5ded0de4b208a5bb2d78fb650137a2113e04470d53387257dd87423b52b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c682b54397234ad80a25e5e6123e964fb4584ba62f054eff3d29e2de43977176"
    sha256 cellar: :any_skip_relocation, sonoma:        "9554078fa9252b2cd160e49f3a3cd2a7d0cf904c452f43e4ceae841272a51105"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "621f203274e94e71a9f5e6bf02e56e6b9448fe99c9fe1b5758fa03b80c129f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9207b7ae7f5f3257f77dd67e98588fc6be26bb5194298cb6819b2df609e1992"
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