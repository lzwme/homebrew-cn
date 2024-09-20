class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.1.0.tar.gz"
  sha256 "2b2fde44443af835e6da6d4d1b58fa9fd830c96bc0258202184e56edaa98e73a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c5048a2e77d17e99976fe521d22f2d085afc6f444c75599ad307fe6d08a7b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab1b2566752e90e340e2f09a55c0b863d1cf2af78ac7385dd0a04fc5b6580336"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f26a2641aa5a63a53a8636216f0a38e2f6f0ebdfe66cbf8bec3fed856d80d288"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1bd14edfe89984dc06541c16cffeb2920baf1d16e4cb81aed3b3ff4ea50964a"
    sha256 cellar: :any_skip_relocation, ventura:       "7d208775a8ef4e2b0774cb8aae7cfdf3e838c99141ede4b45bba1a635e33dbe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a890fa8ecead7419f68370966edb0ccca834d3cf40b8fd8fdb5a06f064dd4d76"
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