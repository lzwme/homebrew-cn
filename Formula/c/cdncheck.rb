class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.16.tar.gz"
  sha256 "7d56993b074d86764624028769a8e41fa1d25040971d1c3fd64c54f47528280a"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ccf738e1b70ae8b216d3dfea6a63c2668490562665fe375baca352c4b397af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219feabc9d66590b3541d0e6231361289cc7484caefa17532e9529834db8bd00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "446ccf9900128f00f3ac7c19ddf79e37bbc594fd85af60140842be5580b89c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ead564496ab7ad882bc4d761a13006e67bccd95d24051fcda2cc44eb87e6dd6"
    sha256 cellar: :any_skip_relocation, ventura:       "7c86b934b22b87bbc7365bfd63e418b80492fb7341b6995edb8035ac7b77132a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9f17fee8c0d477452b3e5697d0560e6cb19ccdefa95f8f6a64bf32b5f8ddfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end