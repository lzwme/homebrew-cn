class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://ghfast.top/https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.3.4.tar.gz"
  sha256 "72bb5a9a32efa6e02aa3392193194127215fe8e302cb827b7202c028f64afddb"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07e194f20e22963bcd68070cb90dd98397f64e13c2151f47155c5ca38120ae77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d525ed05b9bfa690d19d5151676b323b20aadc0fc0d3bee8d0e6794ba6caa5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1237ffdcda76dbd27b060d3a4b74885a17442163905ada0330979e551250fae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc4ce97b002caa2fee3ed817210ed2d26dccce41ec52b131d03fee3fd398a583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0222c72e0ff935f96e07b0460742877998d7df144d4e2876466a0d517b92844b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9803b1c58769a539e0da1fb8327999679c450cfdb0d754ec5178817fc339ae80"
  end

  depends_on "zig@0.15" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odiff --version 2>&1")

    assert_match "Images are identical",
      shell_output("#{bin}/odiff #{test_fixtures("test.png")} #{test_fixtures("test.png")} 2>&1")
  end
end