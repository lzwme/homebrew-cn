class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.10.0.tar.gz"
  sha256 "62dbc15b4109be90ef7bda6993523223aa6f89f39333ea8d35d515edc4ccb98d"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eb99d4fe848114200c0fa2c15cde984ae3f4639c6824c9c267a986115f74101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6961e48624f1e655677cfd606f8fefcd2159129085a8c2acf8cae47979240a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4ae2445c009ecc084ca712d4ed69baf358320f87d275ef78e384e2cc2b8baf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "86d75a0447b45c95a4d1fe8cb3b70710ead55bd59729dd1564bdc1155d6b8ef6"
    sha256 cellar: :any_skip_relocation, ventura:       "477bc36843e33e3f8e517e47554af1ad765f2742068ff8a89502f2b64c3a6b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6242aaedf291c699f8e3fa24b04331fc6fa2c8b65394986271b218f93c8447df"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end