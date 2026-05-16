class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "77e2484853ecac7ff8df78045d61a913a3a691d0f215e32446ac53d928f187f9"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d27a4553c00483c67287ff34d550457670a9f6712e29ee5d757458cf4cc7f9b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4196d5d98362e6b38316d92c017321c7d30181b29df8302916d15f52a2f89c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "868e6acc93e0a53166fb35eb90d8e781d41452069abc1d50fd04a1411a3f5d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e625226317539acd17d91c7729f744d5b19005e09f43a65ca7dce1463f92169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0b5c9cb607d176630febdd2e83cd1cd0ea9b41279dc03bf3e8b8b2c51fbcc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bedf471f6ad12fcb4beaae0d9675796a3843c8bdf1229372ef1ef181972d650c"
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