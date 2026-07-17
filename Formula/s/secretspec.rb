class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e2d44e434be09c381a6f6ca56ac1d13c2c7a6ef349e077cc01236e8600bf89d7"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bb7cbda39cb0a146eae6634de13803ba852fa9965fb58e22353c337a05a8bd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76a16073e6bc3c2523a31f7384851a0a2b7d5b1150aea38169dbfabce8b0e39a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f52d1bb660d54cc5627d06a508117c416812002f6ca006e367a5ea05ce71bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9cfb8c9d29fb693b08198a038e19bbfeb649fe49b2e2eb75da8ff5f6376b6ef"
    sha256 cellar: :any,                 arm64_linux:   "80c4f955d019986774b2fe5db3c9c5288938111ed80b48742403cf9c4560d6ab"
    sha256 cellar: :any,                 x86_64_linux:  "e7aae7f18037075b25960650597facba1036b87456fc6fd11a534a195850322d"
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