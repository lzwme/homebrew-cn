class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "22dbee4241ed0ba4b05a664770efa1b900499f536bf5b852c2ec8c2902b77fb8"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92292c3e82dc18c7bb9cc7a5003f4da275008eb5945d77113601951f5067fd60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c980a5e89e76310d8862b49400e1f77b41ac5799809ae21851beb12ff92d6f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d6b27c7dc61f7a09d3eb2f1185c7e05d739a4eb64f669a48c085a6f7bcd754"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebee400059b1c7ab2f27b3688377c3375af99ea39e3cc56c8f1355103714da5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a887669bc72db9be59b0bab40ced23de43a51cd3b2462461f42041da3c409a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "278778b9cc4063a142ff590f56f67482eb14bf4f20f30a5999aff8a8d65ba1aa"
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