class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.22.1.tar.gz"
  sha256 "55c28e1e3d393ad99f847a1b6aa6aaff2d2e03255f9b798494fc3ca7d23a3922"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a0fb16a39062deedb5c661f03bde8a185521a23ef5af1db544b614f50414634"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffaf6606766b77ebf421b598cedfb79d42dc9c557aa3ea5ecacd4c0083954a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbfb33d7d2e4dafc91542e2669da871436125e881f82259a71a4e63851422763"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c0abf68809161adcc7910cbc1a000025d7c72d0d95e2761776c013b189dfc4c"
    sha256 cellar: :any_skip_relocation, ventura:        "d994e847701bd453292499e04a869b08318e03788a8e806ded3bef182b7ff89e"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6d899073fe46f7766c1cf61f8f08194bae9884071b68827ffe148f98b93313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f2b723b89164ea8b969d527b96d1384e9a7f9e71e0087379e3074ea8e221f9f"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end