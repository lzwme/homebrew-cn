class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.4.tar.gz"
  sha256 "849b42644930808d513d8a50b252acd9af58ebd93eff86408ecfb550084a92f6"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260bcdd0af9a2a206ea8fc6af35fa980abc36a12ea886e67630858988ef47abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3cd2a596efebd2f54e4603db9c5307639a14bacb45471b48e03e12f4237a09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90490f3aede6453e09be091acffc2f67b38bbff2765b48f1cb2527e712a11b52"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69f3cb1aa7d1885377a8c61a2300aad4605b4ec2a6bc9ce2fba464c66b2d086"
    sha256 cellar: :any_skip_relocation, ventura:       "4f850d2a4d0eab9dd58ca50bfc0badc46cc646f23b3ff3fe09c62ffddcd053c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c5e704209cb8ace9c62419bdf47151a63779993e2b8c4c6d7ffae1df57ba411"
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