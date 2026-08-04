class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.11.tar.gz"
  sha256 "862f1cc88ba1006d1d6ce4a8bb8a7bda052c2dfb40164b3859baea79b67ba702"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa7c6e95a3f8bcc1190d12778a592179c4929479ab2d878e48366e75b499c5ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c44e9ad4db97edbb1d7967a1ee790f7ea5aef0568cb7477c252ce110606fa13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c085fc27a164668c9e47c455f6d06d765fdebfc56ddf124b9fdbb3f63f4fa0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "affa597d621e0d826de9fba8e3489099a194a8a1c353be642d2ce6b0df422c22"
    sha256 cellar: :any,                 arm64_linux:   "9b12b9685de56749a9eb515b8b620d0a42d9c3591b46f7fd4fc3f104ae0aee2a"
    sha256 cellar: :any,                 x86_64_linux:  "664bc456da8c4caacb093eba3ac6b62010dc55b9703e945440bf4ab529d86045"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end