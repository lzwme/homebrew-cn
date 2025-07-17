class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://ghfast.top/https://github.com/lune-org/lune/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "95b3941773435431125980f25dcea0511f2d49676e4cf0a2e2095d256300d270"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d5177bf10867ace6f37dc85317b391ff524d33d40b7e7deeeef28c671e196d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2241e3d42ecc3b9e56d24fe26e3d1655cd40abb4baac065b7e0258f738fae91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dbd53fcd858d80f956881a8953c6643265dad7e7809c5164cac40638a24de85"
    sha256 cellar: :any_skip_relocation, sonoma:        "93528413fe9d98a25f298f345b0f55ae487e2f829f489ca112c7a51613a5f2b6"
    sha256 cellar: :any_skip_relocation, ventura:       "a38636f008fc179147cd936f3ea202efd2b9342dc45b73a4e2589dd49cdc6165"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dbfe4a9e2eb0971bfee5bc5ce3d01bc5e369ac39738c7d4857a778cf23426bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39bf1a4a5a6f9411b7a3680e56699d7b979517d08853b4ce31a1fba185e87bec"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end