class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://ghfast.top/https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d603121658a04ad8c13e2afc2548a94b5a492cd960e6b310f606c6912ac779ef"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4176f609defffd9b99a7b8db387a7b4ee4f5c28c4d55944d99bc9ed6a3860fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92f51ea86951fc42263a1c1628386adfe97e414ab638626fa0e73a6b438c9da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cdc5a10a7c553ce264b6bb603dff67491e4fe13cfdace82a0fd5efdc248e89"
    sha256 cellar: :any_skip_relocation, sonoma:        "633567c5c00f8df40905e0cb09608a5ce4a0acdeb7fa25aa818cd5cdb88ffc40"
    sha256 cellar: :any,                 arm64_linux:   "e56ec090fa111c74f116b8526cec09def34d976b59f3452baf58e3b6ce172280"
    sha256 cellar: :any,                 x86_64_linux:  "24e7523e232e2717c496efd6e6bf46e2d1bdd7e42bbdc304401595d2bee4cd38"
  end

  depends_on "rust" => :build
  depends_on "opentofu" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmcp --version")

    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    output = shell_output("#{bin}/tfmcp analyze 2>&1")
    assert_match "Terraform analysis complete", output
    assert_match "Hello from tfmcp!", (testpath/"main.tf").read
  end
end