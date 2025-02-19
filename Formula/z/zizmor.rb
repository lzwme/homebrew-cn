class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:woodruffw.github.iozizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.3.1.tar.gz"
  sha256 "a8ed1b318de38ffa2e1847ae4b66cd44324030cd0fe7239e82430341b39c16ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3781699e1c0d3d128d83cd57cd4b58894eb6ca30bec7a8fab8d7411b8cee3ac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aa08421eed2afe360c33923b95522201544170e27d74ddf08024485b9a63c53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65ddcac82437f43fffc6db4e35ba83901c2967484c15e382c3661f829ab6533b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d12a0b9562129e2bda19721f4dec83c040483a22120d873545715bd7291fa1e"
    sha256 cellar: :any_skip_relocation, ventura:       "041e0b61d392fa2de3d747fea36e1ca0bdfe200b8e73c72f393ff0115c3d94f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab9f69abb5c4681eda409c3c8fb84f50a8d21d1d93fd438e66ab5a1a425b797"
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