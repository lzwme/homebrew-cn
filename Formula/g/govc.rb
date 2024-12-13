class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.46.3.tar.gz"
  sha256 "eabd38a13b53ba42cfab3a89554e85f77631909a10e9d8229cf983f2ea670b4b"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "798fc456960d71bed7d401a63620ece2c925b741bcac8b600b9aed459f55180a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edfed6ec44d9d5f7586e7ae130ecb2c6bddcbe5231fd8d7a09cd2fa84928ce84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ef3b8be85964085c5916e4dbe6ee6f16459d2fe5f73e2d9e8ccd6e4e4653bb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed5dd3d0bfe2f94444d88f755bf83094a1851ad5f310a64ec1c9c2a4f5674ea3"
    sha256 cellar: :any_skip_relocation, ventura:       "7a663e53146e4bc2e88d8e9f547f66530ae4c0d1072d0d080f411615a902f04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21cf444ab571bc4f0f2d8039465bc638682ff2fc32a6f26c3d96be8a0e7d0c9e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end