class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:docs.zizmor.sh"
  url "https:github.comzizmorcorezizmorarchiverefstagsv1.10.0.tar.gz"
  sha256 "f87f6298325b980f5b5415ac2d381302e00cd624528d6b858ed54487655ef1ce"
  license "MIT"
  head "https:github.comzizmorcorezizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6c44ca9a6ec98cd6fc48e0b1d5034daa97d5cab27ffac9a8fe1da62daa0b3a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8642968c355e134b33c671afa695268b2c99b167d0f6fbfffdc11cde4c7e9b1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b37f45c6eea8841f5e7af160f64365a5f4cc9c219acd7671ed5c7afd360f579"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fff49e0bf4b32ef3dae4a7c98f72d2493977440bbeb71c1830038c1dd1993e5"
    sha256 cellar: :any_skip_relocation, ventura:       "7771b7921995e0ff91e239937d7d36059b0c49e856c24b37244a272db9d52f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c13257e10220c0270d8923bb0268fd1cce851ad92010d8fedf1546877cceee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f617348507beecfd3e0f0da6953b976a044eeede86900843a8f9ba577b2d49"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crateszizmor")

    generate_completions_from_executable(bin"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actionscheckout@v4
    YAML

    output = shell_output("#{bin}zizmor --format plain #{testpath}workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end