class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.6.0.tar.gz"
  sha256 "42fe1b4861cf55ebddf30eb599698681b3a74c6ac2114a09720ff534cb6f57b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1f1f4cfde04f63aafcde8a85b9a3522afcb36b0f49d87d770d59f4b0423a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acca0bf21581b569e80cce970a1cb2ec203b363389a58e65d4b78d6fbc70e717"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a5543ae3a5d301449e95774a3b8b198fd5511f061a901fe118676149da114dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe060a87df51d9a0eeb0318b2e456baca1ed57144aa9dde2201b29e303e52697"
    sha256 cellar: :any_skip_relocation, ventura:       "d001fc98a12cee9a7a2d2b0c5674165ebce14fc0444bc0bd1c387c611262b164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28eef20c61d16d1ea7c9f0f8f1597ecb96fa3a461037f4418fdc46654fb396b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actionscheckout@v4
    YAML

    output = shell_output("#{bin}zizmor --format plain #{testpath}action.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end