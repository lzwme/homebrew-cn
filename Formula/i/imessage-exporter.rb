class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.6.2.tar.gz"
  sha256 "c5c372b6e9e416522be3cc0797557b0fdb0df546b0b48e379d18b56f54b692ea"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79751187490085c01bd66f6e00e9059e4ca9d4f3d252ead0c0af8a761db47393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba23b54cbb4f8c006a2f08d94bf548970c8c666a8ccdc4c4b3cb3ebc74c4f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3ec942d1b835e7cc0aa17273925fdd5cd6a4e94c5aad080c7d60db7bb3bf9b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f0d781c61084cc396e18bf53da6682438be8dc7adeaf804f15002841de0c0a9"
    sha256 cellar: :any_skip_relocation, ventura:       "8ecf2e0efbe7f76d90c1dac41d03950b8f816c397d835c2f3a78b216c136793f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235b89d49a0956642fc1ad28a9e013c389a05278819dc57ba971012e6e413e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d5f24d0c724f8c81528ba216139e05cf6ed1fa9176d985c72ae1ceb36649b5"
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