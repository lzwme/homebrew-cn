class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://ghproxy.com/https://github.com/ariga/atlas/archive/v0.12.1.tar.gz"
  sha256 "61f00fac400cb90314b85c08f55aac94f59df2e66edcbd44f87b9740d6f4f5be"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e26bb5b5637876ead23faaaeb728dfdf761f4235ffa2c9fef4d9aff6b2998d0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65109d67718837191dd6ddffe59874cad4bc009ddd07953d87d99147161407b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "996d09a60e7e76d6cee3b77200b92b5972823ebd25593adca9fda35394440050"
    sha256 cellar: :any_skip_relocation, ventura:        "0962ca1aee5342adaff3e3f124de73fb0bbdc94e6d0969d09d34ad62d138ec5c"
    sha256 cellar: :any_skip_relocation, monterey:       "edf903c1dd94673e1076999b7f16fd015b3ce1ace29b969db246de3eeafaa67b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c0956477cb1ec4924ebf00be1a2f8c736640258f872082f204e7421c8a43909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bebecaded300877cb5fea777c1ccbf654bb8feaf34f0e87b0f2e89071acfeabe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end