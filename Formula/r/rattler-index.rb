class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.21.tar.gz"
  sha256 "61946d5d99973b673868e277030f47f333be1f200fbd477b0e2303f836e2edca"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "903b43220ca37ef92118f41caa24ab9467294fb917c6f93699538f0aaacb5b0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6ca8a3b766312dde938644bbfe788774068f29bfbf254ba76882c28cc97f6e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3c43be3783b257efdd40c219849646dc9df05022f12040bce2184f9e9647de"
    sha256 cellar: :any_skip_relocation, sonoma:        "7148b6a7a9809ab94e8466e15af9f92c903015f059f1fca999dbea5bbf563352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a5e2d0e8bb94112eb48973f3a1cc0c3d055d98bf2b57e17f3f05470a9442e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e48d0ba643d7217cf2696f568f3b73d4f13eb9cd25ec24ad456f02c6679f6056"
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