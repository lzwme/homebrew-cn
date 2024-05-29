class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.4.6.tar.gz"
  sha256 "efdfc07f135e4e1ff96c46f7f0a4b2d4bb45a0f5567aa29a9dfa5dbf76a7ab02"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e586dc5248ea15056b54b413acada00f608d264e17066d14fbb8e2fa5767f6ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a057655159f397c52b1698f7500a4386871987378d10c05b7dcdea813bb653d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2facca60722141cfbf4f02a072d43c51ba2a923bcccd9578613c2b48637d7d3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f28fd2f50ca1ae93dee01a2113a138d8fcef7d9a088670205ad35b73d3106562"
    sha256 cellar: :any_skip_relocation, ventura:        "c6961ec14e308c0b8ae3a90c0b8f3f6cf238c7275421e83f49aa510c6e392abd"
    sha256 cellar: :any_skip_relocation, monterey:       "f4b853e8035c06c38a6cef013266b2703dcc22178393df043dd6ba6bb87ad48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10bd8e43be6dd343aeb44a1b4191a4096b6080ed2e81e5069fa1570929bd9c3b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end