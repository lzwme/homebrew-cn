class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.10.0.tar.gz"
  sha256 "ac188a66c496dc503707515b60bff0b9d61bd27c163ad98b1d16465bfe816980"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19bf52fec33f2d225edee6da9148cd0967e7c2f72fba15c0c77c4f958d0f0c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e5a720c4b80474c281a08fe8327edc86d2a182966b439b670f33f766f18f91a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81f5ccebbad9bedd1e01e41feee931f616ab604484655a9b3bcf633df94a2253"
    sha256 cellar: :any_skip_relocation, sonoma:        "482fcfc51b9316d13b18e3c5c0f1e4c92e35d38c227e0d109631974f7c43602c"
    sha256 cellar: :any_skip_relocation, ventura:       "e6dbac52a5df9688893b5ead40bf27903460d3af3629d3a6b69122df8195acc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a5b5a9222bc5cdc1890e467d3d472425c38a0fe1cf6e7db604e4e0621bf06a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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