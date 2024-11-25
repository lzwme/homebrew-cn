class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.2.0.tar.gz"
  sha256 "16fadb15e723c92c10f4fbbff41871632121f0461bee600121f66d0292617e6b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dce2256b08b0221080ad0bf0b3c414e31aed71de78848ddbfcd1895e51c746c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc8d40dcd675ec2d014898c7b30b3e60dc557e5b2b1b8de274be1b22416cd3ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1592d0a4514b87e17b284275844d0f80ebda31a84e4b4432cdfa917e4f749041"
    sha256 cellar: :any_skip_relocation, sonoma:        "61f1b229236e1edc1ad08262b34b71446f52a55d93ba400a2a911029c5d4ca2b"
    sha256 cellar: :any_skip_relocation, ventura:       "66ad15a0fefd21cd5a88f387d3d44bbc12e1157e4895be2575db4247006e1787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601f071c26b6534f58a7cb660da7a979b635938770d78e52c3a8a8932c492184"
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