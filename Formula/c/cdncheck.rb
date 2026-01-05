class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.17.tar.gz"
  sha256 "7dec1b9a5a879fd1a941f9e2bc387d4bbb8d17862f46471486b150a321ab1120"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aebffd395887e1a85130e3b54550ad3f783be80454818a80a129163d77c7127b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5483c5c6c9aa06610889cf2c2c35942c7965fdc4ec16e3a7eb28ba00bda2c5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2462b8a56ea1ad4a9f053b8acf439f2023336259e1ec2548d5616918c0b563a"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b0ec5dbcac8a4fde0d27146077da7de5c58645a63891aa73b6fd622ff045c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe744b2669ee45b88132761c33d5eb5fa8168e8bc5709c433c39f18a736a74c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6789d361860a8f6a9232d2faaa56c074d01c82caab0ccc6ed41299920c0cb4d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end