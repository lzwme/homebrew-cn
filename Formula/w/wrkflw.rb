class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://ghfast.top/https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "3d972f95f56e73f803d0d998674befa97c7e620885c0e81fe131ff6cbabf6bf4"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cdc93b9ceca16cc5ebb3ad60b8a528350432504cfd63100e0bb064eb604a753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6bc88815738aac31195f2bfbce2dd7443bc70ce5c845b6a44c67ab3323e70b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ce38aee0a1152f3abeb775076f94c4ced15633fe562242bce209fb163457810"
    sha256 cellar: :any_skip_relocation, sonoma:        "afe8cc1cd4d6f1f23a749ab1d38c6b73611a28a43941ace73979808e62674b3e"
    sha256 cellar: :any_skip_relocation, ventura:       "ff1ddac302e1b385767a7f77f0dfcab961b5e685352ad7448503c36329a3da3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36181ee18fda7e3439521ecf5e0ecbf85e27b93d6fd80c57193ea06d42cefbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7b9b1b9f46fc50c117d2934e4c9e8b0da0de29885ba6079bebd632cbbac9cc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wrkflw")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end