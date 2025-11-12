class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://ghfast.top/https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.2.0.tar.gz"
  sha256 "be933e8a88456fdb2488c988fc0fb72388cda706b2d81553e4736acd56ea607d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28c6b2acccd7f7a993359f1963fccdb52049c21718096db85d9cf29743299250"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b54d0d2a748ae9dad236b8bef72dddc304a669ff1a0a494645f1540f7c3b3b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad037dbbea7876b6f5690d50df4ed35653d554575ef553016c9be5080b3f041"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b264213cf7d1163db35d0eb7f0c400b2db895e90534638f85a0690b9c7f415b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c246fd24f54ba724fba5bf88b3b6aa8e1bd4e48712733bc3c1e4e53006679d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff5d35dfe1e9139832bb5250bcc554e40b1f57ce6c078e5e3d64a76304bd1311"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https://github.com/ReagentX/imessage-exporter/blob/develop/build.sh
    inreplace "imessage-exporter/Cargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imessage-exporter --version")
    output = shell_output("#{bin}/imessage-exporter --diagnostics 2>&1")
    assert_match "Invalid configuration", output
  end
end