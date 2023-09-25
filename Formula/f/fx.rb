class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghproxy.com/https://github.com/antonmedv/fx/archive/refs/tags/30.1.0.tar.gz"
  sha256 "3b28cc0f342d8a85b5eee869d3ee7c9ae77ea303aebdfacab4e587a0766bdf78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f579024f13ddb1e0ad616de06c025af150d8ebb2b7218a34de133995c758d72e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f579024f13ddb1e0ad616de06c025af150d8ebb2b7218a34de133995c758d72e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f579024f13ddb1e0ad616de06c025af150d8ebb2b7218a34de133995c758d72e"
    sha256 cellar: :any_skip_relocation, ventura:        "33e18ce8bf8c3c2b1a0c2fb266cf8f98195e4082d45dfdc01d546d5d13a15297"
    sha256 cellar: :any_skip_relocation, monterey:       "33e18ce8bf8c3c2b1a0c2fb266cf8f98195e4082d45dfdc01d546d5d13a15297"
    sha256 cellar: :any_skip_relocation, big_sur:        "33e18ce8bf8c3c2b1a0c2fb266cf8f98195e4082d45dfdc01d546d5d13a15297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c601eb4bc596f3ec7e53cc4a78234ca79c22769eb763c6d41dc562cf5287448"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end