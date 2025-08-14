class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "ee296858017e88c142d46c7935c9911e9715fd8dd501583e823839ebb39bd711"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b44b197028568ce76c55379c22f0696afae76c4be12801c21ddc7a692c1de3a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae9706432815b1ccd87e4d1441e79248d465e3bcb8ad029ec9980b87b3f71b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a25943a9059f9c2662114dfee04540a01c11e42ccb3a77ecc9a6ebb66890f31"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a9b2fe6e4ad16f2ab958ee2a3cc09d02e7df5d3fdf96d3c546ff173adfb695"
    sha256 cellar: :any_skip_relocation, ventura:       "866e862614e3706d2233c972ed5d5b579430403a36e57db54445863c86344e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac5f2d0e4611d0eca9d8ed91d9e69bc66696f51fd43e3e8189a64369e98416a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc47679f6eac9c86b00e15f9d6bcc19c964f265ea69a49918779c08e21d10fc0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zizmor")

    generate_completions_from_executable(bin/"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath/"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end