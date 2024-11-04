class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https:github.comwoodruffwzizmor"
  url "https:github.comwoodruffwzizmorarchiverefstagsv0.1.6.tar.gz"
  sha256 "9cd469506b36e0c5cf69d0ce4913ff2a74ad1d6d814a28ed69d384cc5ee7a1fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0459b636a4b4886c9f626cf0b325001fb48a57fbc924351252399d8715a70ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e966fb31f931a7be9adcd9d385dccfde8585523edcd91cdb6e1d40803d89d1c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eeddfce85fc152b29ab84107bf52f280904b2327735154d4391571906d2aa12"
    sha256 cellar: :any_skip_relocation, sonoma:        "7196cd21893a4a032b0e759e2d2c1aeb5c6efb2502af6ced27a25eca22987c48"
    sha256 cellar: :any_skip_relocation, ventura:       "508bd3024ce624fc78b24763c4eff8902b1b59ecec9b3eb42f2f0a22ff912b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac87f1726d66b21ae50732daaf039a33e4d559fa07b463934e720b47cad9906"
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