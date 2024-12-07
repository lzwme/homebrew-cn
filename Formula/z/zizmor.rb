class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.8.0.tar.gz"
  sha256 "6d05a646e40f27a83023e46ee6b4a4d5290cc385cd5a2d36f273881a28676fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be51b9ffde24fc488f5a27ba920ffd63b940d55c87e2cbfb0366b10701a50917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b341cc8102c09b9544ebffd1598d8b02064be3253b6a7a8d236cddadc796dc2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b59d577a97b2be181206928a1bbf9c2036b7b9d2356378b656cf12372b62f61"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f19bc341140ccb32dc9f94895d7494dc1d1295fc12f037c03ab65ed02e1fb97"
    sha256 cellar: :any_skip_relocation, ventura:       "e720c552bf306e3bed5cc7f75607ceb74c9c6b8f25ca69cbfc3cfccdd27e5d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86df433efc3a9e02d1c13487466759f7705353a06b965a641b5b4fc3177506b0"
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