class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.2.20.tgz"
  sha256 "65472351a29a19b589d190d35239f419542d0d7da663a2e525e914a668e1d058"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "987a11382752d3840d02ea4d062bb3cb3bba67e4ad41e7aed2f619310f2c3d2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "987a11382752d3840d02ea4d062bb3cb3bba67e4ad41e7aed2f619310f2c3d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "987a11382752d3840d02ea4d062bb3cb3bba67e4ad41e7aed2f619310f2c3d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "123f485578356ae7ed03682e5cce610b87b80533b79edd0a37adfe23837d3a58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "268f64ec2c636a7bdf471a9cba19f380060990d768019e77f0e1609a4e8466bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4808286a25c2d1f48ba064b651af1bd46b71ada08a542f667db5529ecbb36aef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end