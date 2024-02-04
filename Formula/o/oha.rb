class Oha < Formula
  desc "HTTP load generator, inspired by rakyllhey with tui animation"
  homepage "https:github.comhatoooha"
  url "https:github.comhatooohaarchiverefstagsv1.2.0.tar.gz"
  sha256 "d5460bcd496bc3bc2e26d1cff493f24c314566bc11728caf36b58cbe3061bec4"
  license "MIT"
  head "https:github.comhatoooha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0335c40f503b3b7218b0c5ed9356b1359de6bdf8227dd7570c40e3333ace0eae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7837daa15ce8bf597b5246e4e807b71408722c10779583ea378000c43bed7f09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "248deb284020c65faed24170fd95e20c2843e23cf1471c2d54ea0b3cfc617d96"
    sha256 cellar: :any_skip_relocation, sonoma:         "b446dd0c3242ef728196d44c328e8177b69701464a7de47a6eaa3dc5de903aa5"
    sha256 cellar: :any_skip_relocation, ventura:        "6914bb1047ba640bf1b3d1012d1ca6c662650d3f3d5b43f451d9cfae1257f1b0"
    sha256 cellar: :any_skip_relocation, monterey:       "8b0d6cbba846f9829a0232d387485a00d2a1af9aac653399263aa5b75b2eda5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a729929f7ec5132e78b47a5d206f8ec744b76e4cff0b1b00d490ce719eb8ccf2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}oha -n 1 -c 1 --no-tui https:www.google.com")

    assert_match version.to_s, shell_output("#{bin}oha --version")
  end
end