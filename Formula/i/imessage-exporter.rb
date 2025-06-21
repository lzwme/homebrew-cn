class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.8.0.tar.gz"
  sha256 "077e7215561de70c7385312c79d3209cacdd28bd7ee60c26ee420cb6d33759ce"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "473d1c5313eb309db493a015f920ca1f190d5bcfa938bf30823243b647fee74c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "025424c1c8459033b2f9b17cdf442a82d63915777aab71a0424d1b7404e1110f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88332ce2f9dd01132d4d589a963c04f29fa8457fe797d743f2426423d6875fe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2a2166c5197b11a18b41243742c4e5d2871544da3b03b595fe41080119b6de8"
    sha256 cellar: :any_skip_relocation, ventura:       "e1150f655743ffe93c198be22e5ca9729cfe5a279efb1ee91d199b5628ddd0f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de62fd15c5db894f0899110a54ccf9bc813bec0049373a3809b4d4bcf7141aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab947b49f6d1bc4b83d648eac4a91d5267bf4bd66b6f0b198f68c36e0759f71c"
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
    assert_match "Invalid configuration", output
  end
end