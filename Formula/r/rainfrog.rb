class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "a2034bad6a07ddb2273aac931284d341c219d944b0088e207957831b5302b2c4"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bbbd875cc34c55e6074b17ddba1f777537a8d68d8133e6cafe6b1eb02cf3371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb05f80c4f1e6e3f4404dbea07dadafdac35b325f39d81c471d9bd4325d0437f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7056dbbd94ca055694c5706f9a71ec9012ea2c0b2995535214801dee5a8a9b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d972a05316d04d604036d4277e3567b7c1b45d726edd3bf2065173db290378"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7333da2189db79c60abc49444384b12ecc37833ffcfe6c25a63fb341b3cb6de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acacbdda373a6efafcd4565489baf5ab1a152c608a1fbb8eeeab9f294719aa88"
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