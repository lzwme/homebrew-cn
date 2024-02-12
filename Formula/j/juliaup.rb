class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https:github.comJuliaLangjuliaup"
  url "https:github.comJuliaLangjuliauparchiverefstagsv1.14.5.tar.gz"
  sha256 "62c6f555a3a210ec7b612cc89f7d7117511c6307e2a1890b7fbb8c474f820a6b"
  license "MIT"
  head "https:github.comJuliaLangjuliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ada75c594a491055e51fe277e7761cc24145fa631f84b221b95c69c604e95769"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f055ba15a23fd7398de71f571a57b0f6dfa3aa61c048ffeb39ba563ae162acdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca7dd03a0202256130ea6395a258abfafd71914cb3943de307543db42781f89"
    sha256 cellar: :any_skip_relocation, sonoma:         "2db25c0f58e5fa27c26f930c6b1a43d4f3036d2a866cbe4d2ab4c471ce7656b9"
    sha256 cellar: :any_skip_relocation, ventura:        "ef452df5731c2882a17017ef50cd9105a4287c037fcf7e552eead4265ca6f8c5"
    sha256 cellar: :any_skip_relocation, monterey:       "58b2164f19a8b8765d8abfd3e3533a27d7e8635bd0212bcc59e7509874f743a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec1d31f314d481c4cdbf3376c223cbff90ae258bf88a4c6029a52a072c4e579e"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}juliaup status").lines.first.strip
  end
end