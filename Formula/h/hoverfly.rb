class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.1.tar.gz"
  sha256 "92c17702f2a74e6c76885575eed5ade191e85345bd3050095068503e7a445dd6"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "220dbf08e3f0220945478fed429c2e380ac2e34c245b44de2cda3b6ec21263a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da25ac2f3e21c0096b0864bf4f7e50776562e7bf18298c4729bc2509a45c1e10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f9a040b2cd619fef1dd4f839cbc0d413d4c0fd3f7b0e0f6124fcf1b49d2cad2"
    sha256 cellar: :any_skip_relocation, sonoma:         "102d3fc2b0172ea85f28620b85c8232267217c6f75956ae68c4db6b60344f6c6"
    sha256 cellar: :any_skip_relocation, ventura:        "3fe68fd990af9d4c89c92420e524a3f601e13b287c8e9231502b026a446c8cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "99c8f4bdd4baa79f5087db3aae905b027cc3beae0a883d0f0eec2d4f0de57098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0fdf3cce9f6370bc2683fa7cf0c42328854843597605801e3120cd81397a713"
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