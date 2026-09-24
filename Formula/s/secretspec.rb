class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "fa24f785bae57f6005b306493d5546002d08d71a42da6daf0cecd7a917e0b004"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74464fccedc39c8271bba5749e7ac4838443d3e5f1a4ca672cd4ed8ed2345c40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c3693eaf007f265b6e67159d929ec40e4228ba8b619ab34eef8c1b8935d3174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be30c166bf8bac1a554a0af6645e7828d06c2416eca6f33781b4cc5b7482834c"
    sha256 cellar: :any,                 arm64_linux:       "a582273a96a0fb7213533e6a1da36314e6e1c0b714b813bfa12d645d1c2bd278"
    sha256 cellar: :any,                 x86_64_linux:      "d0b6a81384e1a00c68d337c3f6cb7da8be1e5dbec562b470949f8b78c4bdf92e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end