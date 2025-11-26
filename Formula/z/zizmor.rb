class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "86dbd18ca6c5143b30ff7a50817a57aeb20c07835583bab74540541f5291160f"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaf9fe57d73dca97f3693fa90d386441ca5d39f3da9a1be11ab44444cdbb396f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1ea8c5389d6c6e0d3873bc786bb0cf62bbdcfd20b1d1bcf3b558dd22adfdd5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "161a59800964a2ed9dca329e35eec1df19a6c28e8c95790aa9352f59b3991a0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2059d4efce6cd2eb0cb7f81b57f3f1c027eac0d70c39700ee14af9c4da616b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84583ab0c217fc4bb25d8756ab3c275226295faa5fc83b34ba1cbb699ad6ba9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e925ab43315749c941c9cbce1029170a3d969f02de4c1c2717e61eb93e7b2de"
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