class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "2880165ff505c0e3be26827c49c1c07e5cfdd26565caeb287710d02375b8c728"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "128d27eb3466dd9162d3d0be6b575e3d5665509754e480f22ea3a5e14a7e3667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1aa89ef7de9d086e1ff3eb05e0e0072e4e81c76afc71e1df90c781450248ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "214e6e83a7fdefe80808515d70c6dc929f4afc091e2297f134713ecf6314a98d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c54c6c432d5e58ec984d02b6d5b4ec93158df6ee4c37e7c66a87f5cc11cb98d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b597d7b137c044c41893955b612d69d5d68320f7251f5e7ff8892282207f628d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d328c5362232dd3f352ba0494735d70694da7d5b2b88d8c3edeefd0a63fbb30"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end