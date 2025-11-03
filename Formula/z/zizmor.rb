class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "a5c606b31a9b78a4cc7053f498ba0d7b76289378e8f4d4ef09f1226fa6f4e8d6"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc131cb9416bec559a9d14a6c558dad8997854e95ce4fa8a51c06e364e3378f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5af8d51572f794a3ebbbcd8f4bf03c98cbe94f6e73985fcd5b175f35bdb5c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "384ff1a7f2a6a1985e69f7d145901e1c73fe17ac3ccc5cfa1b13653c37b7fdc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0216dfabca1513349d61b15536a5e785ba156154cc0c114e03e20426ac1ab69c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17049db990f4053963cedb4d380bb4be2f7bd971ec05baee32be86c6fb8a705f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f0c84ac080f72435959100f40ac04019b241c6e0b3a439ad75e9b8b0d8256de"
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