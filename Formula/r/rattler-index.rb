class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.26.4.tar.gz"
  sha256 "2925d3b68abcd6ad6a040672de7b2f08d9cb55ec15357516acf6cae14d218919"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2169badf06a1dba31c4e9e59bc505757b44c87330314fff27fba712f016c650e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e976c3c0969906830738ce71a618d31988d077cbfc5808e9d385575489d30bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f564e2af34ec3bca9502b75d64d426e0b2261d44c788b91a54e6cb4b38d0ee03"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f69df76b34fc58aa57c3abe112c259119c16d7d49650d3fa324f16af8a54567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bca7b7617606c45e75e70f64ec859c74f92c595c0fe65eaf4a43b177fd6c5d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8207204d494a7c94974e9d2024277257be08417743f02392fdad87e0447895"
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