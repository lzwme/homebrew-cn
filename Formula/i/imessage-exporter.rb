class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://ghproxy.com/https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.7.0.tar.gz"
  sha256 "9337023a399c86317b72e8d90b4ba7c1b97b35bc96b9065c3b6c6daf8d11de6d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01d9141820456289b03094a4fd9e295c96556822b21c06ba05f3664ed50c04e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "688dd45d364b2c7f09f0c2817b23fb088552e2b7380b026024402c31660e8bbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5f650eaae874db6dae06a213389d5aa6d6968e37e220debc8a95144356177b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c23c45d5de61027c7bab478e0e2f6d882d7019e4e624a4704ff0ef12526b0e1c"
    sha256 cellar: :any_skip_relocation, ventura:        "9e8c63192e857fbfa320e6ff597f1c7c31a529e1b5edf4d46651713dc0b22247"
    sha256 cellar: :any_skip_relocation, monterey:       "be8e648828d65213a07a92fc15af6b0da74226d3cb403b9c11706550ebcd47ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3484cd50c9c47451f2c543eaadb5ed909813df0524297a53ccda2857c1397504"
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
    assert_match version.to_s, shell_output(bin/"imessage-exporter --version")
    assert_match "Unable to launch", shell_output(bin/"imessage-exporter --diagnostics 2>&1")
  end
end