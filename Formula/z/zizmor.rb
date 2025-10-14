class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "fb8940d735e54377c365ae2d07a41f199058a8bc3500b2bedc65e433aecc42cf"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcb938e10fd9a400c50214f8c5dcb3a95d0a5ebee7149f8d6a03d70d48a1a822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77972552e106a28f78b8c89a410afe276b52e07876ac5eb8d2a359e704cb8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f94c5b71e6a3af92d6a0ab1999acf9b8a8c37f6ee5087f97d83a464cc8ff3114"
    sha256 cellar: :any_skip_relocation, sonoma:        "0172e0bfd08e8cab96c97113470a2f92128373f86b660302a24cdaf9d3e3d9b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53ce7682bb3717c945ad051fbd135603afeb1b21dba7aaf89f3078233a25d5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13f203fc37f10f0c1760a3a2602c8da195b0843c07c1c10245883fd8899f13f9"
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