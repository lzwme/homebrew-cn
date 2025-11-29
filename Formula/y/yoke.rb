class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.18.2",
      revision: "24a63236d51d44194553b6223e8b11fb1b688a85"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d22b0231e97dd1ed03b39505e3c7e4ed6c701ece89012aaa48de17155c2e4dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f00ab0225b285577825a0564aa66a32e5b63c519f56d14773cc9c9edc2f024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7417aea698a0cdb1fd591cb2546be528bf7b54f823d926c68ef0de18c9d091c"
    sha256 cellar: :any_skip_relocation, sonoma:        "863b05cbd014a8f11faf92cc8262e4924267f4ca16782e25319eead99d5e5658"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72e59fd38b14241fba1d1c405808788747013bb720258efa12427cae584c9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd5176abd0b28976f9e2de0f51a25dc9346b855e2e58bf69751611d6f5b7284"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end