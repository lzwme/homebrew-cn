class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.5.2.tar.gz"
  sha256 "bbca72a23fabc001a563f5da301ab28bfb0baecf49238b41810c8bf161e12094"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad549c79838750c6248c91ce8cd114c4e6fa18343820c588e180d3215af830eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b5dbf9b4962dd89bfdb2852407ef02ff53224d824c40280d42bd9359913258"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c9027c3246f2f0470059730f301d1d5a1b0ca4961dc9035d99864b3a5d35ed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "16aaef780247916bd67890e7c06e0d75f07a898242ffd46de10f8c1f6345a66c"
    sha256 cellar: :any_skip_relocation, ventura:       "aeb5809ab09f6852349134469b462d4d60a4c3c9a8926cebf69da77d6b073d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0da77c676075a126b7e83739fbf5240cba137a32a5184b64790ad8617e82f2"
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