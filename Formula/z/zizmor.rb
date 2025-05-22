class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:docs.zizmor.sh"
  url "https:github.comzizmorcorezizmorarchiverefstagsv1.8.0.tar.gz"
  sha256 "6f5f4da30eb7e0fa4b7558a9418b58abd7c5ab467cb2dce330c8189a00668355"
  license "MIT"
  head "https:github.comzizmorcorezizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d386ee8c99c16f33f1f32c0721c7fb2110201771b24f3fc7a772397f6d6ff0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bab9fc4d0b97aaa20af5ecd59413bf24d9e39d305df6508c84684a53a9f83275"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5bf92668311a100008b92f8099aca3335421a7d203f4e4ad1450bf6677af1f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdee4a7829598fa6106e98feecbaba791bb787432190b68623f7494a7661c8f7"
    sha256 cellar: :any_skip_relocation, ventura:       "7b1057ed22c2749cf157dd9e1efdad4adaf30829e5a7effeacadab7a44aa3c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f00d64ef290dddebd31ff8471a7cec7508fb0b0c13e80bcf50c0aa03c78a784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b80ce31632b69e8c347cd8f2410f0a55ea3b737e745b09e762865054bd69df"
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