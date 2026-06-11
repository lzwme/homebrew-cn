class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "e759670461ad963163eb50ef328177cddfa02f47237e0ae9696aedc06fa756ea"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fba60fde98dd95607e4c13b3c5e4e66240cee0a8f429ec2b4c5c3fc6f14b790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eeddbb2803128aed081a5e10268dc03f0a7d93a6314c7ab15938e9e06b74f8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935c8bf94bf646f2d2f542f815b421b14c0b63901f6d0fb75ca009b8875d191f"
    sha256 cellar: :any_skip_relocation, sonoma:        "02af6c907252d1be4efbfa68c4cccd7c6aedb304bc0691f7908418f5f84caf60"
    sha256 cellar: :any,                 arm64_linux:   "dde4ccd43a9b3893ca0c0ea45233dbf4c5d73ed5d46225785d5cd11e950e6d98"
    sha256 cellar: :any,                 x86_64_linux:  "cf9af52aee0d218c646b2f140f1b57582286251b0943012268369fe63522715c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end