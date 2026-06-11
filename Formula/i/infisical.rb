class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.92.tar.gz"
  sha256 "8688ac3a83b493fe2c0591520e8e79cd639e50dc19a4edceb2f15214740f1dec"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e92e02ae87b31bcc09277aba70555612079ba838590435699fa54b581ad0e31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e92e02ae87b31bcc09277aba70555612079ba838590435699fa54b581ad0e31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e92e02ae87b31bcc09277aba70555612079ba838590435699fa54b581ad0e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6f278c105cfe3bd22f69a4d5a926bf4e8f29ec5238ce46fdd6a1564de6eb422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3645d48eaa9719eadff33bc84e47db0d70311cc38328908085f01b121a5d6ad9"
    sha256 cellar: :any,                 x86_64_linux:  "6b03437b91eef0cac821534fa64763312ad5d7800d964fc2d83c0cd3d4ba19c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end