class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.5.0.tar.gz"
  sha256 "0263516f978fa871e77e99d8bfac4cd73e6915087cddfcc765e471d26b226166"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fcb678b04bf14c4e627f8aef04485bea62537c85ca2b00f05f4e3e5b15b43de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7418ba5a8bda2334f464a70e0b8a2575b93163f98e8f355aa8ee29a7e16f8673"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38940ec601c21b51858723685c21a0f3a5ecc14d06df4162fe6ca5ce60bf45cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "305e6666e4f497f5bf8efd59446dba0ca05709d130dd58cf3a0378ff6153cad3"
    sha256 cellar: :any_skip_relocation, ventura:       "cec7b0235a315c3507ef7d34d5a0f3e16d11584a4b3ef6cc0515fb8424f21458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91334faede683c2ab0af326322dc48280961ade5f46d9578e632f5816f67b77"
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