class S3scanner < Formula
  desc "Scan for misconfigured S3 buckets across S3-compatible APIs!"
  homepage "https://github.com/sa7mon/S3Scanner"
  url "https://ghproxy.com/https://github.com/sa7mon/S3Scanner/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "71e9e2e1b48c961466ffaac9eca54a06111741f8d9e595764a9264b50bd3b30f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "808e7b18eb2c02f77e22b4b291dc7a965cccaae2e66347ad815b0e89ae692548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a033513a096efcd15f7b548864e0390565feb938cd722229a8fbf4dfa4ac68d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e4b334536225b03a32b15eb3ca9d692373b3a8a04464656e84a1ba64c9d6d3a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f444bbec2b3cbd6d82b499d37155ed3a74b34bc15b9c7f0f67ca495502ad90a"
    sha256 cellar: :any_skip_relocation, monterey:       "28ff1a53f43e88e77cc9ac39730411a06f381d80a7a1d0b676a7edc6685f677c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd41db4e10d23d2044f1432d8c01a7509413fdaf4c38941b01f942969d8fa31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "565957b853f66237b0ecfb1e976a015fc0995be38395880d0a988f147a9f5c41"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    version_output = shell_output("#{bin}/s3scanner --version")
    assert_match version.to_s, version_output

    # test that scanning our private bucket returns:
    #  - bucket exists
    #  - bucket does not allow anonymous user access
    private_output = shell_output("#{bin}/s3scanner -bucket s3scanner-private")
    assert_includes private_output, "exists"
    assert_includes private_output, "AuthUsers: [] | AllUsers: []"
  end
end