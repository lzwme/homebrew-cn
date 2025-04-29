class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.0.tar.gz"
  sha256 "a3befd2a621aa73a6b514f94d78f93369a6c100b756e6b9677f796d438c244a5"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3447cb382361930194016be2eb265e200ff35601c0f752c7ae8445130cde50f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3447cb382361930194016be2eb265e200ff35601c0f752c7ae8445130cde50f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3447cb382361930194016be2eb265e200ff35601c0f752c7ae8445130cde50f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed2f329d88a951fdc77760889f09e64efa9fbaee71df790d25d109e8e10fe03a"
    sha256 cellar: :any_skip_relocation, ventura:       "ed2f329d88a951fdc77760889f09e64efa9fbaee71df790d25d109e8e10fe03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa20d30e7b30ec2a05e86a9afafefa10079c66e9355893d95db9c73d63f5d6cc"
  end

  depends_on "go" => :build

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