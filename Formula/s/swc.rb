class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.4.tar.gz"
  sha256 "3e97bf4f5f9c87fcc416378d50f3a72be34de2161b5e8a96f6a1bc3061431b1b"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6a824ac47b52f2c11f97b433f0c5266ea79ff737df80a1c58d802e5733ffba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e29abb12572480a0879f1854c183b13a740cff6aaf685a205b68b717e3617cd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5384de91687389afa68cf2ccd65ed476846c7b1c091de694dd16ae5fc74ed0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "39072def517f6e06c8fd44acd7de8d6623b50aed75290d925595d3c054bf658c"
    sha256 cellar: :any_skip_relocation, ventura:       "07a22be8a9bed54f24292bd13c563bd4149683ee7bcf954a11fc623482a39611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba7ddec274d63f7753723418be11861c10eb55c435a7e40f45d4e053b8adc54"
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