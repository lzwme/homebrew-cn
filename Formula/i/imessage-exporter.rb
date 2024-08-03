class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.0.0.tar.gz"
  sha256 "139114b7e05c6a7f23ee93a5f3af3d39ba12b69a3a08b40c1125ce594e454628"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8948ba21433e340f0d87c12008fc268ebbbbcfc64897f0a7fc02dcf6c02f9d8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4198e265517f20c95133e94b9796f1363ddad3dab130fe9aa8a4daebe794df2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de08747b221ca822cace8bc0958987de1daaff02e59e60fafca6de97a3862c74"
    sha256 cellar: :any_skip_relocation, sonoma:         "bafbeeb9de1821254c74b5bcb683a7e888a29af687b1edf657692589180b0eab"
    sha256 cellar: :any_skip_relocation, ventura:        "fb423af36da67e9efca05a0147536cbf3f0516a2c2c18a7f7747f965bfd1cc40"
    sha256 cellar: :any_skip_relocation, monterey:       "9e538074332315e9ee82533a7ff9fa9635d50a16c765b25c10bc5923123449fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51bf24845dde36b01c75965bab8d46d8be14f47837c04205856d6b8d2ffca99"
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