class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:woodruffw.github.iozizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.5.1.tar.gz"
  sha256 "80d5a483a56601a6ad224dace459f303d0ca304c182d22f37ae157c1e8c7e2b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2cc75e658c1cd8e855ad228edaa4d22fc2b359f256b0ec15f7a61d1d628e0a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0df0a4cb4d80ed5f0349d208737fbd459985c65174ccaf4f255fb23af893db40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cef1e025b6a44845b279d9d908ca63e209c707f3968d6f9e402a5b2fff5613a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0e6d4592d6e2474f0857009f9666d6c237b03bf76a67d68cc74ca94c648656f"
    sha256 cellar: :any_skip_relocation, ventura:       "d32dc9ef0bd4f3234ed7fdfa7d8a304c159e8673a7056b479f636b48ef1ab729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba69185e0b1cb5870c665a061ad885cfa88b214f795def24e12dc5a3af3028e3"
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