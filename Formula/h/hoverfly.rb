class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.7.tar.gz"
  sha256 "d0203f84a4e1137978d3420eefca13768f85d6dc40d511a184d338fcd240114a"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e96ad474253dcdb1f6300fb3c81095bcf2e48829c1a8ec2af03b99a3b72ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e96ad474253dcdb1f6300fb3c81095bcf2e48829c1a8ec2af03b99a3b72ebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6e96ad474253dcdb1f6300fb3c81095bcf2e48829c1a8ec2af03b99a3b72ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "499108b76825c2602ea9814aa69c93acd75be98507d0c577071921e55d9ae087"
    sha256 cellar: :any_skip_relocation, ventura:       "499108b76825c2602ea9814aa69c93acd75be98507d0c577071921e55d9ae087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982cb424994466bbf66f3f2537c2bc3e1814d4be6774d6e26a4e68234ca5e689"
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