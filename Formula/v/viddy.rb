class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.0.2.tar.gz"
  sha256 "065ae0fd3e5e5b822932a72e62c886ed287bf7d12ba69ce3b1a02071be772bd1"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80249c89e82e25914cdfcbac158a74590c23879d80510c4b3f67ef71ff8421ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7d7ee4fe772cc30a5359665faebdcc17cdadb25eb846519b1e75f5890df9f44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc52602963e50c8a1fce223e4d15791e8df458d557243812850a48e9adc57fa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "76c2395049f80b528645a1757607705b03519e564ff84f6c10ea4c1c9d624852"
    sha256 cellar: :any_skip_relocation, ventura:        "dfb5093caafe44fab3b5c2ecaa0cb14d9fdb631134bbd0668e163fac6a8462a4"
    sha256 cellar: :any_skip_relocation, monterey:       "a46d90680519cd9df9f4abce0c443aa3d338f2fb89fe466ff2953963563b2c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5df1eb3bd73417cdafcfaf5fe7e917b3e0a174e7f15ff4e5be8ff1c642e6d80"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end