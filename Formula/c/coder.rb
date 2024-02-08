class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.8.1.tar.gz"
  sha256 "a8d3e04707c9790d871fb5ca044f363aa5a16dc9f253e92042480dff4567ce17"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53f47d1a4e6ea1d7aa78b70ff406b250d39a1995528d1465a77869b9556e7061"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83aba0ca6b74d5c0d4699ccc172eb87d17ad998a43f5c31fd336f3344d4aa897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32731bb6aae380948268e9d456727f3e8bfb8ca1db6c24e3e89a1885da2ab5a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "607bd27e6631b752074746a2f63e4c9b1f60f74a9abe3a7ddfedee012b5ae952"
    sha256 cellar: :any_skip_relocation, ventura:        "fd1938a39a894701ee611879dd40fd48215871fe46174910cc908e83bbb67ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "b86c7445ee8b63aa6badfe6196a353a6b4c5c2f0320681a27e74046f8b03d332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b9ba176655a976b7c0ae46684aca88d44a7f67f7721805418eaca01d335eda"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end