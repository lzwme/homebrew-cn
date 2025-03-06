class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.8.tar.gz"
  sha256 "928ba9b5f61f9fefe0f8f8abc5e4144536fa6da6b004f164bbe95cc4908b5447"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e946c836833e0f94a9317ced236d11a9d03c498c313f908684b0fcf81b4f1ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e946c836833e0f94a9317ced236d11a9d03c498c313f908684b0fcf81b4f1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e946c836833e0f94a9317ced236d11a9d03c498c313f908684b0fcf81b4f1ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f16bbb65e74585b48ecf7b150a5fedab9683b1fb6b183ac014d097b8e25eff24"
    sha256 cellar: :any_skip_relocation, ventura:       "f16bbb65e74585b48ecf7b150a5fedab9683b1fb6b183ac014d097b8e25eff24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5376869637d0149307dc7396c12646e849ffb8d174ce21a21f0c1efb37c3c4b"
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