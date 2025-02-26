class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.1.tar.gz"
  sha256 "6e177b5319c40d84f32d0fb6d80e4110deeb08d773370affcf00da9a70af58f7"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "106b9e240a5c19d9ab2de3ea1c69ae5640368fe90129d00a93816e19c4f9af29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a87716f9949fff3092ab865875dceddd587c7679ec4cc046aae3b596cb0b665f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18d76118444e0411cdf4208d6bb7634691d898ea3dececafd48e9f9cd0bc6aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d0680dcf7c65f188dfae519f058314ffcb222c5603253766c5664688bdcdf89"
    sha256 cellar: :any_skip_relocation, ventura:       "780fe4a5abb035fc3a0bf465dcd0338319db0cbc600eed584bc492ab4cec67a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a307bb53e6361c0e26812e5b4819bd62aa93b70acaca74304728ef5af49aaa5"
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