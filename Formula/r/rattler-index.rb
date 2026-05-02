class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.28.1.tar.gz"
  sha256 "d8ef660f4abf1f8ee8afef7565ab0088b790432b502770892dcaffddc401d9dc"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cf21166293ada2a9cb9fb2e81a494898486a22f2ef314a04aefb630a248aa37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "690d021a2e0296651368ddecf4998ca4de1af83d53ea74085e780cd06e1ae2aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16faaef8c5f85be1d55cbe386f27a10c2ce696541eaa872030c071bf1f674ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "263a4f42f499955cfcb4bd11f9daeb82a17b59cdcc15fdfa7bff8df0102bbe65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70696eab32e2e128803eea0cd777b46b6b156e060961f492eb1afb47b80c4a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4a8a000e0163a779533e4942a0128612e4185b098d0fd3e6c002b9cd104d05"
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