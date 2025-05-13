class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:docs.zizmor.sh"
  url "https:github.comzizmorcorezizmorarchiverefstagsv1.7.0.tar.gz"
  sha256 "9564db26f6e134a8f23f6d92c48a25c7cf457fed5de5ac76643cd45abf098129"
  license "MIT"
  head "https:github.comzizmorcorezizmor.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe997f8811e7eed3e1435a75557269e5ae510b047dfc169a641555a699ad2dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89921f02ba68bac05eaff29c8c1f7cb3a707f9b89710b25b51dfaa1b4755f86b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c43af3dd890eb1782e27aeeb772cf589f724529b4199c879d598360a7bbb5c44"
    sha256 cellar: :any_skip_relocation, sonoma:        "29dfae0331e97244575914cabd1858f30d7f5b17d18fa36524fbff4e0287a5a4"
    sha256 cellar: :any_skip_relocation, ventura:       "b8c53542d2d4c4c99c370c4e313013afec187bc3394cdf9e443858c52575325f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcce1f98efb0beaafd24de5f3aa74a6d2d5dd8d2d563d4589d5df0959194aebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f32ca3503f3465cad4d5fe6fab6905e10753b9c41b16887350b3d3cc69020821"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

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