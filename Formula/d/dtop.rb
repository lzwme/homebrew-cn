class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "3d6ba93043a6f126a1e56d9dd611da8f151989e2c455b1bd83102112c88b4390"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "577ae9f73a96ae23bf75d9a02ccc1c9f77109b851ed43095544bf98ece077878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f36f664ce3c6a541b37639093258e89ff73c22dfddeacf7359e333292ee0dbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d10df74dac3603b3ebea2f06529b9c581c258f0dd9b80a3992ed7fb35de2047b"
    sha256 cellar: :any,                 arm64_linux:   "7fb7cb7acfba846a5a93e64c5f43249c76be18fad099de63578d31db45f8ca53"
    sha256 cellar: :any,                 x86_64_linux:  "025bca9fc7b7fc41f48c691c1a7575d48dfc01885a487cba0e823e385db78643"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end