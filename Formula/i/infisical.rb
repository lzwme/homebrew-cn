class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.88.tar.gz"
  sha256 "8104f928c55bd5b83a6536feab0657ef499a4c34310ad7b10511f03325162509"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c286de051f120bc499f93548df261295ad3162b73340eb4c2f1c28168dbbe149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c286de051f120bc499f93548df261295ad3162b73340eb4c2f1c28168dbbe149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c286de051f120bc499f93548df261295ad3162b73340eb4c2f1c28168dbbe149"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ae7fb2bff87dd8ca7374652d22cd9317a76322a80ac5136c441e231f3ad352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b183c30b1b26457e3a4d1c45c5c10332a5c0cc727e425025586dc4414ac8a7e1"
    sha256 cellar: :any,                 x86_64_linux:  "7ca5935584014f12dc43e728a4534904166a30774405a646099f152b69ce57be"
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