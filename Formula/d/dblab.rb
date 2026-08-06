class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.47.3.tar.gz"
  sha256 "b5db551a6650cb87d662f979a4f9b4fe0b39d07fbbd291c0eeff7f20a9687a61"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2b4c922e25dc94b6d1017ff5235779718b5ac71b5ed0c40fe327ee73646de5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391e66c4021fb5ac398f2c29b89f65ee0c3793ef50ba47afcd2e86e1fbdbfa84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3148ffb568256af277f893658f38a8b1a870fa5d7d2a053f37a46a709b5ebb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8074ef3f2c3162b7e4a156cfb3e1383359924b338b164c7c19213fadfcee843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9d1bbebdbb15530c26fe83812e5e56e83e965fbcb69ba200cde7a37377b375"
    sha256 cellar: :any,                 x86_64_linux:  "2162c696b0d257aaf25e98a10b52689fdc154ed2a2ff6da12916268b0483631e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end