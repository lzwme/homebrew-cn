class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.2.tar.gz"
  sha256 "63e0dcc0e1b1ec8ec46a76828637fbfc29fbcd9e15ce2706e16e34042c6add65"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75db254925580c9f5be313d56bd350220a43bc4ce10c5d0c6b7651328652aa68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b9cee4779c2af930c593cdfddea8066f43d70a92bb8e1d0716690d3a2ec3f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fedf3b611d3fdec43d70df218abfb041c412b136698d0a94de8b1834fde3cf97"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6837bd5aaec951fb7a7b9b3e712e02034f09472dca9ba77407bc6fa94285096"
    sha256 cellar: :any,                 arm64_linux:   "eeae0dfe4a5214b12dd6bea35c152e8d126afdfaf217818261a543631445a5e0"
    sha256 cellar: :any,                 x86_64_linux:  "b88460057773ba6ef84808f2f1ed2b8498c27bbbdd79463a24e9e971c58fe278"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end