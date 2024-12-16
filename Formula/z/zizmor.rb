class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.9.2.tar.gz"
  sha256 "470afbb50f7e65d2de48fce4353c43db03a267977bacba3adc88d5f563d2a385"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b24b9831499e16670bec41457ca7c8ca5b4ceea041027d45d7dc717314a3f228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fabaef8f3cd6029bc8fe4634cdb603be157f30f2d5faff96656db96b35ae21bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ac62b55bc2c5430c7afa713f705ddef92ea495481f996b355210b5e957842c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5af6901e0616423169c6183b4126047b57e4714dc731548d21a00b84e1a569"
    sha256 cellar: :any_skip_relocation, ventura:       "d7aa43ef744294b047a9afece05fc9ca5cf4a46fa580d82955ec418dd1075821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5408bf5cde1020833cc32724d08a77ce77be05d6ff1863b71613cdcdd06f62"
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