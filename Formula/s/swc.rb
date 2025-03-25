class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.13.tar.gz"
  sha256 "1970cabfc98be230c501ab22b2106709650cac747ba8a2c902fd609a2cb6db45"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c0834426ea877192971833fe5661a1737d6f506071d901442971d58ab1ab249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c251b48ed171395ef92cf9a351a8b149fa926114975c7a9e7d3fa27b1939eab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0cb0b75935262692094a876d8f70c138200dd9a7f7f92d295ea83f7b68fb65b"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a9a61e5d270cfe7634ba7bad006068ffeb54ba1ee5c9c43884e9df4089cf8b"
    sha256 cellar: :any_skip_relocation, ventura:       "7678fc91c122c8d1640536214754cf9bf9245c09d39c89b4a7b23f065a418412"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce9c4e0b556223209a70d016259fc547aadc0d623d5e0bced359263217ed1d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03140a96850c3a8b0a7b762d9db2990ec1f2df94821783e1ee40863b2762a6ee"
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