class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.12.6.tar.gz"
  sha256 "292817448a5fe1c8c82d721ce4154806efde082aaf513808528e1a9983e3273d"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "230f66c58a9b97ed38128f053be6ff0c97e65f832cf90840694b21b5b1e2d728"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4f37bda55e76aed3470dc6c694fff0e515f438c079054b74aaf0acaa981286"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39119bbaf38513c01ba6cfc65f6ada8116ce673f3c2d88e4a48f83d05e5666a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "267b42beeb9390516d2c61545e3f36c6a587260ee52737e0be69defe5cf6af18"
    sha256 cellar: :any_skip_relocation, ventura:       "fbba8304338fc8374b8b52441162e30e060a40edd5fc0a6ae3ece09271e39d98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "610f3919cae8d935d9553b5142a2ee23ab96df1b438d9d65a18baf0d48ac90ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e1c8e846ae33fee930f8bb2466e7a1d67b75b0c360fa1dcae1d03b5f15c5e48"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargoconfig.toml"

    system "cargo", "install", *std_cargo_args(path: "cratesswc_cli_impl")
  end

  test do
    (testpath"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath"test.out.js"

    output = shell_output("#{bin}swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end