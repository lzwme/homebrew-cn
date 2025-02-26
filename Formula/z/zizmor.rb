class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:woodruffw.github.iozizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.4.1.tar.gz"
  sha256 "4f881c11a15a465fa12a83faa48e4549db2c8b487b66a44dda93d4614572a79b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fce8bc690b264825f4532504fe2c7fae1ce67506898c48483682b9cdfbd00720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc2769dc9484eee63fe13f6d3aa7d4acc517f72aac103992bb79c4185f37ebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22b77ea0a38b7e72f83142c7732d1183a80211fb1a434bbfb27a2b63835dc882"
    sha256 cellar: :any_skip_relocation, sonoma:        "69c45ab7dc84c766607fbfb52d01571a15547a40cfb1bb032d3617d607b4029b"
    sha256 cellar: :any_skip_relocation, ventura:       "ba3deeff3db7bd5c27aa9b7863c7ea3b173236ba73b4c56c10787a32d30e0d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4bda943b47f06a40674a7ee296515e4b67f61f5db9b14b13b7283fe2d866d9c"
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