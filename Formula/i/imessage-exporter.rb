class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https:github.comReagentXimessage-exporter"
  url "https:github.comReagentXimessage-exporterarchiverefstags2.4.0.tar.gz"
  sha256 "cd81342af7bdd8524d845a4e94a75a3d50f841f7b279151670ab7975cd246723"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21bdf000967fa0701ff92e878401dc37360bf788eef885a518c50da00adf9661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130baa3f8194f0262151bafd8f249c99a9a4b643a46cc132748254901183ca05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f96e6082c878c07f3addadfab8062017751de48b71e0820049a7b522a1d624d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b549e5e8485abd5979f64c6806e50f2fc810b0839b6c0d0b24e78521b0ec9b8f"
    sha256 cellar: :any_skip_relocation, ventura:       "34aa52774258b041abc402601559ff1b5fa7639d5143fc394e5118efd0bd6c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eee2db3e11f80892b574e66bebbb46b5c57b9b1a20a33c21bbe8075f48b27ca"
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