class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.15.0.tar.gz"
  sha256 "6ebaff932f7c9bddc430782b36616e453ef47ff1acda518fbfb5fe48ee45d0d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f72eee486ee8ee3a728e38520213d847503cba090faf276613435aaab00de1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50570f15a90d259274ff5b963b149c0f7a164a14683d1627b8dfb6915bf5b79e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33c69a3a5b29d97d2ba3c2420cb0b67d2e24aedfc21107e709aa54397b0309b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a1714ee7818f8303635484c50a4142f33a367776d854b2fd3a2e9b85dc1a11"
    sha256 cellar: :any_skip_relocation, ventura:       "cf304e532fe7a205188ead926cdecc04bb9a831a129574e2a14b36f28669913a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eeecda5d5b2cdffeae8891a17157e30ea1c34be5ed7b3ad510e410af8eea6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "245131e7b56672bf765aa40c7563b7075417958ff270c85edd7fc2bb603c5c61"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kingfisher --version")

    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end