class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.2.1.tar.gz"
  sha256 "8ba693a0750cb1f7033d5bc4dd01d660987458165ae791c043f864552e1dd4f6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4feb291e443f820c729d05b26d481303e12d619c6bb5555ef60dc4467034d46a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3551c1a799523cec84de149a372fd8f6f17219dc529270116e3d623313077e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e3e3db5460af777c2c01200e53d66cd30eeebef186633a7428ec2eaf9a26498"
    sha256 cellar: :any_skip_relocation, sonoma:        "9773a38d0a1f69ba26a2e4dd43689a08c3604f3a47506101449a4e4ea265a776"
    sha256 cellar: :any_skip_relocation, ventura:       "e57c014d7c9d86f1d75c074c9db28ff63baebb766659f9c651bd1a9423213cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "543487cda636e02b6a94c5bf778342b9b92a93a6ca2bf2519956d02f032e19d1"
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