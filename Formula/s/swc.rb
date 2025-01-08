class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.6.tar.gz"
  sha256 "167314ff22e09b993b6b65a94679c9bfc7b020bcf67e858891d22da8b18ceed7"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78640e7d47112bbc223f731ab0e774e614bfa92d8dbebc68a3045ebf71cee8c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ff3303640866346a8181a6a6267ec5aba9661a35227e503f059a8b2ec988ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b09d2bdac750e4c9a4c56846f07dffd143494bba0edd9fc3bb93422f46209b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb1e76b59935b77bd28056c5a8edfbabe0052f335ae89a0344332a670be8b01a"
    sha256 cellar: :any_skip_relocation, ventura:       "a4b8b399801cd1cadb5bfe498e07337281a0c72238d7fa9c9a73e6028ab2c606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f80cb656ffecefc5130f703553cf089fefe1075c9d9d4dbcdab423f5f50acf9"
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