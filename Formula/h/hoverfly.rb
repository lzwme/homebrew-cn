class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.12.tar.gz"
  sha256 "ed4ab9e318908ceaf92cca338dd1743de5742a802a68890c832420d2d491faea"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de11cfd1d8ee21b10e664ac7c0ff63433fc931009a16c05df1072e50c07c3738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de11cfd1d8ee21b10e664ac7c0ff63433fc931009a16c05df1072e50c07c3738"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de11cfd1d8ee21b10e664ac7c0ff63433fc931009a16c05df1072e50c07c3738"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4c0c9685b8c1f55d8080881095b71ff691e0eb4d5d90b95be724ae7210977a"
    sha256 cellar: :any_skip_relocation, ventura:       "4b4c0c9685b8c1f55d8080881095b71ff691e0eb4d5d90b95be724ae7210977a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a23139f328925cb001004795ffbbc9bc2318f9f9f5c5eba72d2de246cc6ea5"
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