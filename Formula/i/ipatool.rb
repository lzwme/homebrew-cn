class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://ghfast.top/https://github.com/majd/ipatool/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "c44b6bc36cef8364e685d7a290d10d0120f26f2bb3644ebad4cf28dafb417cd6"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ccf25212932d2ce6c25a847ba33e6affd3447251cebc4edffd6fde067ba2cd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2031b6efdbbe183927c195b4c52b4fd26dac375634771a74918186b50611dad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781976115cc9e3af856bf0994bf43663667806b6390f6394429ae5f0092b25c5"
    sha256 cellar: :any,                 arm64_linux:   "ed6dab4f402fb7b0a55d15749ea998d569157b8d9d569bdc3156f63ba425e0d5"
    sha256 cellar: :any,                 x86_64_linux:  "c918c09600e20786ed37ea39c145da90837780ece8f848a5a31c170dc3fa6397"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end