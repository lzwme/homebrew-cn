class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "563f670fd2603932ca722b726e51617d414ca15cebf3391a1f031ecc037c5c42"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05d84ec0a78f8f9b201e049f6e52479ff38218564b8fcf319240cf27ebafb5fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd9c9f238083bd498e31123606b2cfb00363efb8a841e38ec370f60f9a34d5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f347cb3a3a6eadfeaea15bd635c8962cfafde5ca4f5c29de3648ff9c169076f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "63ff893bff973822426f11213b1becce4f1993dbd877cc5db3b2c4614e6ac05c"
    sha256 cellar: :any_skip_relocation, ventura:        "8084040772d0d510cd09e2471fa39ae0983b1922cb6ea6ff50f02e0944425a80"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f9bc8c825f25962723df03196a808eb247c7a83c36e8b29d0da8dc2295c55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95ec06901729bce93a365fea29bdb4ccca335896fe686e98610f55b8f6267f5"
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