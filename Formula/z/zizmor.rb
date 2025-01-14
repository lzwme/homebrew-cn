class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.1.1.tar.gz"
  sha256 "bc2a1b5e08a1b786029e8fab3591090b2b57a73070661d0749088840646ece24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2b9cc262a26404e8c9a86f43bfdfd1404097b610ff7b9c57718fa3f080b859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65a3ca7e3fafea13d86c9344cb0dbc944ef85c435887bcbfadb6f17b5ad3df21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e738dd9dc9d97f2ba585134a7f54af06db15cb5c487031cdcf10552d1e73f2bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a34e4b9dda37ca419d98e4893475e55115f080d7a2f5b733f6ed57645859f50"
    sha256 cellar: :any_skip_relocation, ventura:       "1d0cf2803a86b6eb33514affd8436567f5b62198988d8c7e36a91ca7b6c6ee77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f018d0ec29e7ab390c2a438411761bfbbb729bc640ac5ddbd6f09ab6ef8c539"
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