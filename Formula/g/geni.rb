class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.1.1.tar.gz"
  sha256 "a24239a3c220e1285ef386444e03bcab3620348a4f3cf8d7cac7b6fcd985de30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a4ec8f6576f76c321a8f751886bcb38a3fd403f2cf90eccf06ab9c80c9c5154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c9a5f7b6f8ead19a108aa5964d969d3a74a2acb45da2ba07955e1da101d7772"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9846b1f612a5241c7449703f896b0ad95e2ff0058b33d2499dbaae4010128479"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e85d99e7a164955dbb55d2060c210060d5c9371bddfc58c3223011a987e5368"
    sha256 cellar: :any_skip_relocation, ventura:        "32678ed810c9331c11e859a9e1b947e23724b747a81e65d1036ea5d0a804e2ed"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2c74e9cd9642b47c81da2dac17a4bd2451fdf8697c7cb28b46d049dd389f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ed74a9c3748ff5cb54b8d2ecb15509316a0dd48d161b98c31987c742f0322d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3:test.sqlite"
    system bin"geni", "create"
    assert_predicate testpath"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}geni --version")
  end
end