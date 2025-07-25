class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "2ff5c24f969058b5eea95fb33955b1e10f5fde0cbfb1d21d5d16c22467b0bfe0"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e9591a2f606b63c5b29a3eddbef3a0c186e26c62200888ca2e1edf9a0f85910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58b9a0f5d738ccf2d7c196408ab69647afc300e2d38f38ab8666be70b4d5d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f15f30eef7af827c55531a30da2485abb93f73bacdec27f179201d4dfb3fd583"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b7138c317c67b8ea7ed1b93e95e7266075a148e9199b80eef0fb61e0b420f5"
    sha256 cellar: :any_skip_relocation, ventura:       "9dba59415d5a34cb243f5e684adff0d6ee466a2da737868ce0d5f38aa2f2ab5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d7182dddd8d1b8372c8f79b2095d98ad29dd03ba4924bfc14626fc06efbdbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5786880df375a8f8303bafbec61b2d509252e49d7b8ecfba37700a606aee8935"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end