class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.8.8.tar.gz"
  sha256 "6b5b6ff0e33372f74cc1a2a05f25024eb92052c8ff1ff295b4d3418c09df615b"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd8c6da1d0ad2de44385fe14b551ea9562d54e9795ce7ab8277ae821acecb0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "044b1be234147fe3c6033315ee89a4329cda20b68bcbd9fe6123dd5abaa94900"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "116d9ce74c512d3abd613ea8b12138047f1c7f2e2ebad35567bc0159cb5b7bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "162835f2bba6a1070a752be7430b3bd82c1bfcb6469c1954aef8eaf51f14e522"
    sha256 cellar: :any_skip_relocation, ventura:       "246130225fa9fbe9f17f7ef2e39f282b9f61f44a19c755492fc188dc05237ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435da2c9249152b2a0396e68ce60a206bc4738532009c419fc0824da3ac5f38d"
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