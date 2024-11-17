class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.4.0.tar.gz"
  sha256 "b634c06e610bbad2a23759460c0324fe43fb859a9cb1bcb3844da5468f0b11e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bab0a4be541db8179c7062533ad48cbf8c60daed8feb2811cee6742783ab05f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afe4657c2a9b560e8be00ea80e4d9084efd1cafb7e1e00930f82b54461fbaead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d2fe34c3d5e1d5fa8a2556e29981b1d50289b604c3a2ea585b2e225a6929d0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb8b7df6ff7e387813b537769897dbb708114472a80182e3b42478893885de22"
    sha256 cellar: :any_skip_relocation, ventura:       "3e659da00033f646291b0013eece35f01b35f6d5741fcde1187fe16cf3aff76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7a217ca3ef028d0f50c07adc304d9d8eb324f864cf2c802d7349b302f871c2"
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