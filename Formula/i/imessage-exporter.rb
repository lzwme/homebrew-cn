class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.7.1.tar.gz"
  sha256 "4e02e3b395c33b9cca086336b9e3b6fc4830d9ff5b16de5d92fa6102e6502f1b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "440034dcd3eef669505e01befd1db069a05970ded10dcc7e738cee40bbe19812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab8c2be26c0fcf942eb41e5b07dbd07d1737334a665615eda9bc87eddde56946"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6061991c50c97b0493a10a791ad6f1f51dafb73418cf85a7cbe326c1ba0f2707"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bd17ea5ddca11d562dfb89633e652e3f46bf187632e4e21a3388bf1cbcd8af7"
    sha256 cellar: :any_skip_relocation, ventura:       "fb8e6aff799ed70fb06f00452339f08d9a7ce64e0dd44fad289c518dcae85c71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5d9e44176717bcce7e06a8c4a10efb0b2534c21863fa249bf13119ae0f5f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc49028a93d5ff81b5655a99035119e8596cba6917684edc9bddcfa6c4f4f225"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https:github.comReagentXimessage-exporterblobdevelopbuild.sh
    inreplace "imessage-exporterCargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output(bin"imessage-exporter --version")
    output = shell_output(bin"imessage-exporter --diagnostics 2>&1")
    assert_match "Invalid configuration: Database not found", output
  end
end