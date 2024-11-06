class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.2.0.tar.gz"
  sha256 "d65714a8d5b321d14306959ab90b22414e73b2e3aad613cd466fdb525ad2f393"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a5a3d7bd1a5399dd0717abbc31f6c23690011c0ff3cd38fd2c16b4fb1e25d6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5896b65c21113a82667d6361e6b04855419fb00ac1b2d38c461b228b8a57f44d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fea5d160c98864a1dd0d7d15231e8dd5c14c85b1a1d4b29993c2aa6b4143f0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dd5b886855c835244ddcef9c9a6ba049f5b390ba49f87a5440a4c4ce75786f0"
    sha256 cellar: :any_skip_relocation, ventura:       "3bddb8c3c8b46c16d845120b4591312c8b3ad95121bab834fa07bad1cefcc671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2fd4e9c39c18a645d4ef4e654f3b4b12d7a9c95fcba2f1a1791378eae6d5ea"
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