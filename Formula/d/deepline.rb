class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.284.tgz"
  sha256 "0fe03fe649852fd07a1f7fd91bfcec04a957c2f0d58c05dd1e3979225471484a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72e9f2005461438d0de1be850ee1abe59c829ef572fb0c7700b4725bae85e605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72e9f2005461438d0de1be850ee1abe59c829ef572fb0c7700b4725bae85e605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72e9f2005461438d0de1be850ee1abe59c829ef572fb0c7700b4725bae85e605"
    sha256 cellar: :any_skip_relocation, sonoma:        "f253ae82c502b00bd157824edf68b488dcb057b150184291d51d5f2ea6d3fee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b617b4e6f5e3686631338827a665359e5f4614c4c951508dca1bf1bf26df4a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a372b4c0afcbcf699585bf12d530a5a7bfb3d68efd5be3ad81b55ac90afd4aca"
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