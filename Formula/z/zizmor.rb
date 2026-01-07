class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "57cd9d7f0dbb88646adb07fbe4f76815c1070eece5aa7924ec74a688a6da31ad"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f751e9f0ac50eb592d8d63e8a951aee80af4962dae964b5601d61a34aebcd5a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22292016ece2cc4239275013965f91a81f8788d365d9a8193e037983e2431838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c29942f91ae1fda186acb25e0f3d32bf497e605e8234ad886bce17223e2bca58"
    sha256 cellar: :any_skip_relocation, sonoma:        "4454fdeb909b1d2aeea2db241d4601044d2db9355b520fc3db4732a15882f9ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b206f363d8c120f1ddb1136bcc9c32fad85ec031d61268d9ba41f706980a313a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82edb431429c3c777aea1107c8192d85616dcfae5b51d4bb92d3a785aeeee938"
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

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 14)
    assert_match "does not set persist-credentials: false", output
  end
end