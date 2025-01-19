class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.2.1.tar.gz"
  sha256 "ebb06c6880f9ec384ab07dcd019bb2f8946d6614ae53604f992b9c52cb27c9fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10dabf2d5e9f270c20c7b05e44c74efe9cc3d42e9f9abe297f3617d45bf6ffb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620e3b4eec04e7331e60390216c191e310348a875b92ad3af21b9798815eedd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "767148ceabb1e105388c605a4df34c475fcba742d614d0267549a06896ac31d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "263506ceb253100c40c109fef5123d41d948eba7db55f8e511e9e9b7e5a8f636"
    sha256 cellar: :any_skip_relocation, ventura:       "228a6d22836e13f3f33044caa54b1c0c5bdc42707b0554f53d1e54e2b2820e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc1593b5d129364dcc8c846f265b9fd6cdf96d51f25fb6e5ada1c4311ec5fde"
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