class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://ghproxy.com/https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "cc59da0b2a302b533af5198a71ffeb3aa939c9ae4f65337afb5effc681dd599c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a591b4e52dd9ce272ac288d1fafd1932e166080b385bedea16ec458af4bea65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec772914b8fd3ab44610f7c49016b315803f88e199ec5c7c7f54ebad5cb087e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbff2adec56c152308477c0423b87f6f9a1d5975e454851cf6248e8718afa1d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d34488061e28076d6e69af33156a67bbafb51c87ee7a998858c162c25f66d14"
    sha256 cellar: :any_skip_relocation, ventura:        "2335ecc8f7daf9822508bce95eb909dcae7c9802cf82130661e4b4dbb7e96d78"
    sha256 cellar: :any_skip_relocation, monterey:       "03733f14d26b765725e3695ea1cf6112483b5896b4300ed0dade8e2401a2e0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01497d9585fba19f95af58aa3841ffb2a55fc23a148c4a0cd095619f00bf215c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gotpm"
  end

  test do
    output = shell_output("#{bin}/gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat /dev/tpm0: no such file or directory", output
  end
end