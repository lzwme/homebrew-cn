class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.12.tar.gz"
  sha256 "77cdb5c52ea5c9c846a8cf53a34b66fbd54d8d6042154a6677702a20b55830d8"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a420db750e2d1c706da5fad57ee671d0b3eb0cdce29e93c4f44455fa99478ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a420db750e2d1c706da5fad57ee671d0b3eb0cdce29e93c4f44455fa99478ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a420db750e2d1c706da5fad57ee671d0b3eb0cdce29e93c4f44455fa99478ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b86caf3a7e66c38c4ad40b77fda694d6387d650b85104781371a378fccff3de"
    sha256 cellar: :any_skip_relocation, ventura:       "9b86caf3a7e66c38c4ad40b77fda694d6387d650b85104781371a378fccff3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7eef5fdf0f2f298074a426846aca42badb9eeed94f521e87c976881fac17ff7"
  end

  depends_on "go"

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end