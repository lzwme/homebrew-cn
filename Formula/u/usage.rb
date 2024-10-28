class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv0.12.1.tar.gz"
  sha256 "6e9c87ebb2cd8b681586a79c4a20e7620843d298e497abc7ebe49201d19d4a84"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d33ff727c733d1cfc437388452fdcff189f3b516488c423200e9c2bb9d45d8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a7a5506352590c239f34b840ca69e326f87dd2a1d96a2196f26ac10e7313be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2deb0eebf3bb9916a95307d4d8b9434a37f2798a95b535bdd2fb815962b3cba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d5763c11942261025000119af67e9b333e6629c028ed862e1c1de09da8d2511"
    sha256 cellar: :any_skip_relocation, ventura:       "72e50c7bed53ceb8245ef3e7963d0d850f93e366a465f50bb30be940df34a01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd322f3069c15928fbd9554ff034fce5cddf20d1288add50cb5e3441d576610"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end