class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghfast.top/https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "cf639c2efa2410699e294689f1115298aa9dbc6587f198a839f27a310c18c6c0"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52b37dac968404a51d6cbc1c8205adf08cabc627d64d6628e67f07c12d6b5d96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92bc884325cb2712c98a7f13b43d009e204ee2a523d0f7859d0aa8ba2a8e53d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fceede90dacfcc2bc6aba5ef276bae058b7ef3685f5159532da3b865b1d4a412"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b2e807836ef0e0a72570fa98eee3465940e7f34f0085216767823806dcaf783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d61970e42f7fc7dc545d1dff11e6607d2b5180ca176a487bd07c10ed4103538f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6172ffe534f7bdf63af42f5703c15b4e6ebda7b7a2923022629cd01caa8cad4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end