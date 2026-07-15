class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "2ef4347065e91b9a07c337d7161085b494866b5239605440b457cdcda4318136"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "475a4ed39820e4e7c28e998a148f0ad117fab5f86ad29192c9c31deff86e4b8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25a1fa3a1dc4ffa5e3ee301eb9e1dff579a4786ef2f42e0542b6b542e61470fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248d0f97ddb0d4d6091ba5c91848d484598c12ed2accb04c101d231a5e6e884f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56aeb5eb1f6625dd5dd938907dd05a9610d67e7fc1f3d427768f0b8923f8462"
    sha256 cellar: :any,                 arm64_linux:   "f1ad4dca51efbbaa7fa8531e724b20bec9643a4d841dfd0044a0499fcbf78e55"
    sha256 cellar: :any,                 x86_64_linux:  "bfcdc9b9b5a2da7e3a84c43d74f93a5c723280ef6d725becf6f56a9a2505aa7a"
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