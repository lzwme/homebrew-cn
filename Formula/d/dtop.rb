class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "b69a8200d467671acaae99598554ab6bcd83cf42f68d4d8ef074031123e155e5"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9c7b1f00b19fef2366cd739cc6900674de9f6fa96a2cdcaaf8edabf4c8e2d55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb6c7b05a8777aa216eb70108b5d24095ece21f8c1f2949af99fc3bbe8096429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dda3fb967bac5b4b657e0ee3a521551df6cde43f0a06823d3513807f507c261e"
    sha256 cellar: :any,                 arm64_linux:       "5d91b12c4523990e0430d683bf74d4d8f39cfd363070aed2f07d22f98dee0904"
    sha256 cellar: :any,                 x86_64_linux:      "ee826bf830e951bf4fb965364d7cb7f39d99fff52fd276463019d2048383c9f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end