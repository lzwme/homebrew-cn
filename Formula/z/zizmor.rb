class Zizmor < Formula
  desc "CLI tool for finding security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.1.3.tar.gz"
  sha256 "e76db16b7f4157a1381cbc3b3cc5d3236379294e3e0b9cd0551d54725bf8ea8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca186daa7a8636495790696ea0c3973f4f9644e8136a941a8fdf5a957096aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0854d674d6dd8fb467fc103692be00267da5bae1aa109de50d40d33226bf624d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d514ed91cc9526a790948e0010380cb191a7dcfb2437c8d4879cec5c181a0302"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b55c87fa830f907c0267ef18922b87d9be5e6d596cb81d7e3d2fe935300196d"
    sha256 cellar: :any_skip_relocation, ventura:       "c287563f4962520b2b6ecd1ea7cc786fc775f64977434ff7dc71fe7e606d310e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4661dc813c792da375f5de8d415a3742de58fa9e6a80a2f45f156bbcd61fae36"
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