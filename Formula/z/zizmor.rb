class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.3.0.tar.gz"
  sha256 "fc34e9abb9dc23aa1f2093c1ba2fa66b3de7f63872af9212eb4e7e9f04b56fd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed1c807c9e74cf04b726bfffaea5675f8e2e53808996a960b35340da36ad9c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccbb9f5278e1f1e54096ed6076e98b9032b978cdce23eeaf9936af306fbfcbee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f53b7f71053f5eeb364024353400dbd26bb16583046311588f2b30cefd0bf78"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ef8b9512aebc20f5b60c8c59726b88687fd467dbdb50d0c84b85cb1923fec4"
    sha256 cellar: :any_skip_relocation, ventura:       "bc041f021bb1e0fc850bc36024fc9275df415b75df1f21954fb8e63396ea8e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f97ebc4657bba502de43e00a21177f858e1c2c91948b94ee051cfad331ecf3"
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