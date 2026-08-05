class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "762cf61e5ba1c2dd3b91e76d860f965fb1d0122bdcd6ba30c00c2cc115035cdc"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b7e9d1fdc93d888d6711fde08d515a1a6a35885513e3b8e1aba6a49b9e89b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b6fd002d009bd5fcb40f030f82f65a58a860315fefe34dd621a4159b639dd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c577a7b79595aeb8edc49fddceb1ba8d75b14d3b41f600591fb1c6cac4773c5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f93b8d6e761fbb3c15a0504f394cbde7533b921f70c0753163ebd2b272f5d4a1"
    sha256 cellar: :any,                 arm64_linux:   "cf778ccf8739173f47df63acb92759404bcd48273297fe8daf8fe0eed767cb18"
    sha256 cellar: :any,                 x86_64_linux:  "e319ae26b4d4b42d056896affd6f91d1fcbf3682138749d3690ce647e41cb1e3"
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