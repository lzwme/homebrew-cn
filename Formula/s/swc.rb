class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.15.tar.gz"
  sha256 "d5937cbc47c7fd2d4d616b43cd1c57284092bf2003e934440e1430c58d418042"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249a3baa443d7380fc6aca74e9f7b0338e8816abf6b7d60605631482b5042251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d865a3d55ec613b8f74093263ee350bc2eca45dee15a5d213471a42578f3c35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7cb87b5a55277f9cf8fd312d4e90c5b96f6fa5dd9a844c69c4b977e974a76c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b1594fceb91e8933c517f9d0d8fa8054de4ea9ca544d3af0bce6aa5db4554a7"
    sha256 cellar: :any_skip_relocation, ventura:       "39302dac43c9ca0b00f24fbdf8c74a6af48b688643774ec4d5414b661c3b0bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46dbaeb4f7f9cae7c417bcb327c5e6e62152cbe8f89a1944b845c9e09c89472"
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