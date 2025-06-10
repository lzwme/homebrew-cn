class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.31.tar.gz"
  sha256 "55dc37f56aafc1841477e55b94ff095a977e640024b241753550704b303bc0c0"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a792ac766e31d9a3cf11d9ab67bb8a20c4ec63fe4bb67b7bdea64324ab6391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6fc66e58c0e0598cacd4966956c679ccf0ae04501add013b283643b8e723b18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d9ef8743c6e00037eab6140e991544d869daeded1f030c49787eb557b7654ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fe604ab714295390cbd2226a94007ad6dd70ddd02441c0f1f02babebddfbb4d"
    sha256 cellar: :any_skip_relocation, ventura:       "167762554f000e82ce7481e7bcf455370b10665f6ce375af48d7e2494474833d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ebee5027619970228164b11339e88b10a1782f2a0bd214e6efb2fd3181c7cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "145c1912e61fb1fb323d20a84ccaf7b49c72d2b48c3be9a27c2eacc6551bedfb"
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