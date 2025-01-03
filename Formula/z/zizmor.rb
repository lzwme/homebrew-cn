class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.0.0.tar.gz"
  sha256 "ad7dee0870668a961efd5bcfa7230c636ad1978bed045a45a0557a5da0838725"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "093efc76b87e5af900de5c1c7ea837dcdee6950df14cec8cee90320f9cc98e63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b647b37275bc4ee7b9b0e6755a0569180aed35e8d605e7a35b31ddcfa155e2ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e766fbb7e09875b4c990272678c8f4282e24a44d173b991792fa474ad6458eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ed3b89a163cdf404d87470cca8bebcc01b27fa0b025eb93c8072ebe29edcf10"
    sha256 cellar: :any_skip_relocation, ventura:       "b315070807c4da915ea7174eb33a4532dc25512bacdc2bd916dc9288fff17aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9d4c42d28c71a24970bee9dc51c2692e11c5d44dd0664813f8121e7059363d"
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