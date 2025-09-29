class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "c236755261a9bb85ecddc0c3c0a34caeb79e23e77bb0f1c0d0b6847430250077"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98f7a5db7db83a4593624b29d23a6b86557e9008a3095ec91d5518cfd82f7a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e1b31c02b49959fada8463ce2a6b6779d71ae8cf2ac166b53a99cb9013fdf9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0b87b5e44fcbd62597886f7aac89bcf8878edfdde1f808ef1be8e07d0022316"
    sha256 cellar: :any_skip_relocation, sonoma:        "76303a1eb2314500f19ce1c25db035441e5397a0f5ae3376274074693efaa4d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e694ed3682b39de15428552d229e6e84226c97212d8113461cc5e9ac4c9e1a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937f53feb55bdcea33e1e2d3708f044d8921e14f4bcbf48bb7a1cbeab12bba73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end