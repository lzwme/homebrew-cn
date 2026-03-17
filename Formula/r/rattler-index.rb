class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.17.tar.gz"
  sha256 "f6b413f1c27318e1ec976e1e3b87ef98237b11b69fdcb1d6c8d1415cf8696f69"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da83bb167ccdd493cca8911811b1a3b643a0565ea025d76f403fd897dfde71e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69927a2a7c5f7d10c182594eb45477503fef1641d39206139a895f539b26f254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd49e2ec550446b66166e9219a2618e600123e76afb42d5148e2d012ea0d54f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f47a637d1182d470fc5d986d6dfdb36486295b8c6be3f615e0f2b7abf1a3d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f7b98fd5c697b4030c30162551fe51180adde0243fde023dd064a20bc14321e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e491dbe34751a9d515fcfd45e7ec9973928edb2e47839afd3a92e9fd08581c"
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