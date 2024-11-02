class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.1.5.tar.gz"
  sha256 "a2c7d1ff25b6c08a212c876c99231c0a33f9b7b1059dd6a1e0c33f79c7ff1374"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ca13418a2c5feeae8125fd1d42b419732ff0ef0d79cf9f42389d028ad4cb63d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e349ccbd38a40966fb5a310bfaefa43b5b0944d0cef4da4353c6afc2ea040507"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc9d4762d8200e769db38c27023f6591bd2775323e26c934b4256c8a2a2474d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf685ff99cabd70d9ec0c904667ca2d3512c3aa4cc47a3856df9f09df3a749f3"
    sha256 cellar: :any_skip_relocation, ventura:       "0a9376fdb09f82e0c0709a59c609bd00662bfae461b9c9aa617a34801eb27059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be4226889f26a33081fb0d2bcb051a070269bbd3dc4045e1b5ea06c47992b2b"
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