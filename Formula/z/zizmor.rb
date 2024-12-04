class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.7.0.tar.gz"
  sha256 "35d5215fc1d454782f65e9cdf99ff3c5eb3732f970074fa37f82dc2c1e2a05ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71b4157bfbde60d794bef2f92098f17c2b9ad1b9dc44c5da5da0dc0c5c3e5af4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5992e0585f02699c6b5bcdca2205302a59ed8d1028a2ca3c4491ed050f9c215b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "205a7f5412d6d685d0a00c0c2441dcd22efee72eb204c322128daf4bd4bc2824"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df6cde6986992c3aa618b020b649416fab7bbde44bed10c5489ae3d7f2f2883"
    sha256 cellar: :any_skip_relocation, ventura:       "366437c215f7010eca7d72e14ea86dd4b2b645c1c8524b8e3c711b20dc7afbb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9634364783e564acb85ad896ee4e3b7c1757b44002bc05ca035529caf1eababe"
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