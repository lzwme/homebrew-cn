class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "a92b15bf110085248336cfa1e481cd618d5991dfde8840c6db71a1022fde363f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef581acead99c459047cb131cb04c51afc54a7f3e3a21fabd3e61f3afbd518fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd0a7e4f4ad6063c93a7b1e258394e9ba7e04693abe6916134388b77b42cc69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3584c5f7a7e173baa523ceb407b2aa2f48e5de5e9a6c46894051bd62e1e7792"
    sha256 cellar: :any_skip_relocation, sonoma:        "23e517662b513efc5600abfdc5977d04ca3373a77d91161cb09e331f12fb6a2d"
    sha256 cellar: :any,                 arm64_linux:   "cc9d7ccf35e32696e8b34ed91b2a1a7e0b4c94fe487a20799050edd5927606af"
    sha256 cellar: :any,                 x86_64_linux:  "205f442c9c126314662877ce9edcc9fd936d85890fdaf0ff3a0ac78fe60b5898"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end