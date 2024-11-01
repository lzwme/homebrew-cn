class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.1.4.tar.gz"
  sha256 "4c064b8f46f22fe3cf7e9dc9b029acf12e18c1bcb4aa817b21b2d0f0a90e24d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "780eb17d4a2ceb3ac5934534076d3ddfb3fddebef76652dcfa327eb059a62dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf4dbdcca7e6bb06833f298ed843ddab8a095411e69e381f90394d0b7f76630"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "798d796e35f1685d84e40586b3ebb811c4dde71b1af5d0ab752d1d90d1856b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "6decf91b5bc32b0f6575586985764e93a3b365cafd31887a7a0f507f1929a402"
    sha256 cellar: :any_skip_relocation, ventura:       "f6d8b4768107b476af56f3dad5d93febd6274cdb9f14f96b81d086cc1e7a4dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a1238884a3fa3e72b063dbc8a9ae04df2333f9a7cdc2245ac018b18d10335e"
  end

  depends_on "pkg-config" => :build
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

    output = shell_output("#{bin}zizmor --format plain #{testpath}action.yaml")
    assert_match "does not set persist-credentials: false", output
  end
end