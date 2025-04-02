class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.16.tar.gz"
  sha256 "a2231038f822515ae011a788fad1b92983740a42292ba925abc3776ea321c43a"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd766ac50eafc0c6ba4df9e25353712bf7e32af6546a464eac798e5053c635b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd165e0b108dcf4ac783fc3a41b891f0a5db04563c248216c74d82c7bb64de54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a88975859b0fbf8e562c8a93a5024e13a851d516ce18ba617b293e0c6faf1d5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1569c0256384493f750ab52a71b296cc0281ce330a9721b817b35dad55814a04"
    sha256 cellar: :any_skip_relocation, ventura:       "7c4efa48ae8cb362c2b5bf3ba9236620cb6ec84b93767dfd398c6d92e48b7c75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb038d5a1479db01ae0b172fc2191e74f6a7037527ddb385c065d78e905d408d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c3e615985f34b7487eb3d463f7af40b5bc9afeff37a732e00f92ae98afdf29"
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