class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.16.tar.gz"
  sha256 "052906c35c1b8367281aeee8b56286494dfb07fea7763445bb8500abc1c9eb2d"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860af7baccc7b162bdf436d5c089d04e1492e5b353e34e91b170ad77458798b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5921201a723f249dc912815b3c8621eb7c560f5b2f1d04b7c5edb9e81c9347"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30447fad05ba1662019dc4aec910a7e66b95d57a7c83fe3c3ba57955e0c39aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c2ffaf5404e350892b536466cd41d36ae537c3df5bccb01901f769a165c3ff6"
    sha256 cellar: :any_skip_relocation, ventura:       "dcedfcedd1f7b9fe9420b9ab6076f7384a911fa022a0de40a2f3a9eed60c5605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8c5d61177f52c6724df2a45031b0c9dd0ae9e0f18d58689c04b8038d52935f"
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