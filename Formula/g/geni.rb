class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://ghfast.top/https://github.com/emilpriver/geni/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "5530fb7fff8cfeaecaebe95c0d68b93a757369997872ed48d30d8d2f3625992f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "571e38daab774553490d3e3de2c5d09bcefad8313191498f7f611b85e65997df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a255650f3d9485e2107ac5c3c7c24ec6145acd9817be23c1fda6fe6a92a0d2e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f24a56ad668cd64fc8efa4443e6da3ccab00898f9c47f5bf045ededf318470"
    sha256 cellar: :any_skip_relocation, sonoma:        "583030f57ad040198966cb9307df19fbe3a8ce17dd97956745a85b24cd96d943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8090f1e35e8de4e4d581680fb37292f04142785ea0333f14e627753fdfd99106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7448803a172c040f866f004e26580c54f38b1c4caa2a5ed25871cf180a02d23a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_path_exists testpath/"test.sqlite", "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end