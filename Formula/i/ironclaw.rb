class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d14af1a713c122b0696c7cbe7ba4cd85c4dace700e63a1c772a7f976cd8635bc"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7980bda3a05c747b834a1eac4570f29c0827955b0fd6fbdc5a9882cb96d0190e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e2756158ac01f8df2cedecd00bca1e8c9e766699da9ca238612aaa9762a174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e98c637f2d655b2d15949aea974e13317e78522e239315c88eb7cc650b4b8754"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e86b169aa6609f881d50b0eda5e84855328bb12c626fbf5ba773ab135b38d0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3aab2663e42e4b3a0b318b9f9a1b458233f1d886c7b556112eedb3fb2660286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b983c4f1f9cc0b6139ad2d51ea2a3c1e9dd6a383f4a71cf4791c7e6fcbbfcd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end