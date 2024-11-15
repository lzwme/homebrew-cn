class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.3.1.tar.gz"
  sha256 "0b213d7461df9100727fede185c7cebbcf4c3bbea145dd02a289fa6be8610f6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fabe71d02731cd1ca527215e7de259ea551471d10fe4bfaa5d0074da97ae77a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba0c7c99ceece77bb0c66643b64c0ecc50fc42fdc44b41819b2704c4a6db20d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64f429f23ffe1bfc642e857214dfd830543d8282a7efba93e4ece98b2c13d134"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3a854f0cb5925962e23ff851b8d935bf3f243765f52b6f73cdce7283f1dccd"
    sha256 cellar: :any_skip_relocation, ventura:       "db44eab80d1b0115075c25b19c7e4ebea8ea2b8546f60fc1abbcc5c461c52f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de22754c3e8668100c23a828dd71fa494f15f5e7f179aac66cf96351adc8c28e"
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