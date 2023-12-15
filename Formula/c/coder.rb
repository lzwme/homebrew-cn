class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "21b1dc6192eeb8282ac70f316b9ddf23565f8229b2577b130f4e0801adc5d0e4"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32b0ca6e6267da43f813a867b6e02a5be2f70ccf7020f5f59bd03709cf96305e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "846930f751630fc937c2562d3706d8c343a9660c7fc89378b4a0967b37f6ba6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f48784df4b32800eb4e9b5f66ea15329fd7955a85365a70f416016a700ffa66f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9ab850c680b04d7c2954c370befd65de4e8ff81796e6bc2f66ccfe8eea72ae6"
    sha256 cellar: :any_skip_relocation, ventura:        "f5b4fdd7716ae92ab7baf457142b11205f5cd37568bae94212ab7f5c39cddb6f"
    sha256 cellar: :any_skip_relocation, monterey:       "37a56375e53dfa37350c0b7006a05744ab950712c70984a59be2700a42c97cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca067f575c47f8ea8768eeccf1914ac766d443f8bda8705b3364188c85f032a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end