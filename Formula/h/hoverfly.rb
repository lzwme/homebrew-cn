class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.13.tar.gz"
  sha256 "21d3b49f6da7a4f021c7d31947f9358b8900bd6d3426423006d27031b67f95f5"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49af20d77e4bd9f6e395af60273760b46630a54238ee8b3d49c0cb709fe0373d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49af20d77e4bd9f6e395af60273760b46630a54238ee8b3d49c0cb709fe0373d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49af20d77e4bd9f6e395af60273760b46630a54238ee8b3d49c0cb709fe0373d"
    sha256 cellar: :any_skip_relocation, sonoma:        "156c95e5a7d54c64ca65976cae5a7e744770e1ba2b20203b1e0003c1181ec165"
    sha256 cellar: :any_skip_relocation, ventura:       "156c95e5a7d54c64ca65976cae5a7e744770e1ba2b20203b1e0003c1181ec165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8067449c86ad05f48f1c73ef9798a52b27a3b0556eaf0836cfca0970ee499ce0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".corecmdhoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}hoverfly -version")
  end
end