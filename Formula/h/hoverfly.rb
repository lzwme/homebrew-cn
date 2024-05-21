class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.9.4.tar.gz"
  sha256 "c94d0b0a3be43c61ee3ce8900430ad571eb213d0daabac779977d93205fefa4e"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b6db398c99b1c16a37242522b0ecac4a35e78124dea4bfbace7068107cba008"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7d8280b91c4b543c60b67c5f5424a99093b385bc46e46f2ee652bf673b9226c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cddecdb2b179200c69683793d71842d1ac6698b3a505678eb8776f1f964553e"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e59ac43f1a86f57c657585cb42b29bea768351c145240f676906fc5453bfa0"
    sha256 cellar: :any_skip_relocation, ventura:        "de2230ff92255b6bcafa883c437f459d6f5d097aed21b18b2a779aa4ff430eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "e4d2af6409bde22167a5903f23f0e2950c7e1b5e8dba700e1347121761b8b1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c86c589b7854bffeb2679898cab4cc45fec217c5d75262ba4e8254675240cc8"
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