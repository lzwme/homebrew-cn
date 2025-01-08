class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.0.1.tar.gz"
  sha256 "ee06e79ad68f304c49762c3edec8dd8f9054b02dea8dab45b05b26c5ff3969b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1974953ff3302b21776ef34a4422573be7bee9eefc2b6c7f7c7f83e76da8b978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4e91228335194f22edfdd77a19a6e6fad539fffb0eaf8893e0d9c76ddfde72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "848253b31144b9ec8014f3b1077ed94643778bd978b5e784cfe3aaade3032429"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6c39089e1b5b040fff70ce5e12b580417cb6e7bdc4b080c1c23c6b3af82c38e"
    sha256 cellar: :any_skip_relocation, ventura:       "5fceed67c193f87b60f185f7331235f22ee9993d90fd0beaac1f7212ea1d2798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1d9c24cc552ed374d0720116ae49c44f278490aed0b0b45b24268864aad3d4"
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