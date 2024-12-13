class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.9.1.tar.gz"
  sha256 "d6477e8e57bca79c7b4b92c98baf8af268fe66894bcb36036e0e555cb4323d44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa5c1bdc8f0a46aee784b2bc938d787a122843efec2106d4497a17aae74dda6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e81c3fb17b935aaa1c16701152a23a923f774b28b5fd788c67279e8fe8bcd04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bb323cc33180c60b58d61da3f483b6b6e673e3a2d97f0ceba7d3814b46b5adb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8a89c41e39e02348eb0448da22bfa9a4e09d22759e3e0fa998d3a9b9f5b395"
    sha256 cellar: :any_skip_relocation, ventura:       "831a9e6cee192c52148f4c9aba76facb77698cc76ef8f87e45ac0582fc284e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "663a6f76552fde5d443dfae54c4454dc04e119b184e6a87b09b4eed1746c9373"
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