class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.14.0",
      revision: "4415620e18eef221579f334f2d0687a605b54b72"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34c3a81ae6dd2675837db2d334dfa704033d2363ceb4580c46af9517c60b5b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b32d92c9b3d72e2ade703ccb5860289ab77a550173a5b71b014f2b09e1c75f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "895f09511438d62d7229d8a0c0413bb76b39d61c65942e80bb28a758a5311e21"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe9addb373cf238241ee3fa614d181f1334987538e29aec27a1f6f19fd4b801b"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b6e15e199a9318baa7550ed341da77f8f5c344d4adda0f78b3e811fa3f84ab"
    sha256 cellar: :any_skip_relocation, monterey:       "6e2673d4923ddb21784ee5576f05a7ac6880704b15cc4923fbc69a0198791298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30f417358355e9cf44bd03b14f64ad77bad96fdcfb6fec707a8cdb5260f4d6e2"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "No AWS SSO providers have been configured.",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end