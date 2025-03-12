class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:woodruffw.github.iozizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv1.5.0.tar.gz"
  sha256 "111eb6a2814a9eb0b68ed32f37b8727736de1e299c4d74aede4b833ea8c36ab2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927f3f4b81af2537c5edf462ef321f56ced78665f4e2b3b35219c199984069d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e89d69cd9ac72c17df2d8bdf35a5f4baacab062ec4630f4905f6edda5ca2583"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9930b8e699901c255492e79dadc69ede9f4780d564c862fbe25d73a7618ba69e"
    sha256 cellar: :any_skip_relocation, sonoma:        "708a6a8e58ed934377ce12972bec8af65b3c7fa7f5c4ebf7217319e5660f9010"
    sha256 cellar: :any_skip_relocation, ventura:       "f9a205d4668b11ff2250cc4a104f761b1f4b55a16060f01db13e34831b64cc3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f298f6aa7b59a4dd08238c86a7f921f4c006cab5cf0870835333ec9cfab987"
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