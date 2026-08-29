class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "d42eda91d2e382b6ccf096198f807e354a95312a4e932c3234723bcefd2d3f61"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2dfb293dfcb26d452fa94944964617e4cb9845c9116e4b0dbaab39fb86d7b92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a8cfe99306d2f95ae41f5b943f63c81587da5c5962662720392800b1522ad81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4876023aed23ba9d023b1aafc83304903f8f38eaa92022e86058b94602218e1"
    sha256 cellar: :any,                 arm64_linux:   "bfad6e4e1c4d3102eb1e496b61af3d876c9038b116362b7ab3409844eb5278ce"
    sha256 cellar: :any,                 x86_64_linux:  "c23279c9600aabf2a6c003cd18a43e01c0c8313ff0ae74315eed17af543ac3ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end