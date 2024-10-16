class DistillCli < Formula
  desc "Use AWS Transcribe and Bedrock to create summaries of your audio recordings"
  homepage "https:www.allthingsdistributed.com202406introducing-distill-cli.html"
  url "https:github.comawslabsdistill-cliarchiverefstagsv0.2.0.tar.gz"
  sha256 "ca48908a0d4c9b2cdc72a74cc6ec983f3d9ea665ba10e7837b641dbaf88ddf65"
  license "Apache-2.0"
  head "https:github.comawslabsdistill-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0945169c404d9651481553a66e74eccc15dd9fc3fd5fd7090db762c64a679b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b696b679a1e1dc19ae9d5a6a5b88e70fc63f94ea91d8c5025cdf124530f4e027"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81fa507cd1d2a3a9d82f9ddb27ae523496744c8be016b6431867ea534e32a2da"
    sha256 cellar: :any_skip_relocation, sonoma:        "22935921422088574b9f67baa4ab10db9ad4f79ac8adbdd0604faaa2af0594e9"
    sha256 cellar: :any_skip_relocation, ventura:       "72272c4021c3c7fa364464828d0da1bd03c675525a8c649fa6333f45e26e5d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ebb083671dbe450f27a1d29caa892eb1b12e1e54a11271677984e3622fecfc"
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
    # Most of the functionality is in the cloud, so
    # our testing options are basically limited to
    # ensuring the binary runs on the local system.
    #
    # Need to create a config file or cli will fail
    (testpath"config.toml").write ""
    system bin"distill-cli", "--help"
    output = shell_output("#{bin}distill-cli -i #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match "Error getting bucket list: dispatch failure", output
  end
end