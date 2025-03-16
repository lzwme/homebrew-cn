class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https:gopeed.com"
  url "https:github.comGopeedLabgopeedarchiverefstagsv1.6.11.tar.gz"
  sha256 "58f0fcd9e9caa6af3449a8265f2c6f9d21df050996eeda2825ae8c54825e991f"
  license "GPL-3.0-or-later"
  head "https:github.comGopeedLabgopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58890e8df0506dc36a567750bf1d47abd802a29125ffd9bd7891c210de703b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd95327e4f0ac3037056055b3157444f32d59fa99d4eb327fedb8923fb6e45bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19713caf95317fe50756e0caa524d5de13421ec585850c50734d1b40e3440076"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5e6f306bdb4c838f84a15cc89171c6bb913706bf763d8f1b29c051c10287792"
    sha256 cellar: :any_skip_relocation, ventura:       "329730bde9ccb26972a634060a964ed6e3e5a12c1cd5966cfb185243df109186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43c7f0aa535829ac56440cce653883818bbb7f3555eae5564f8100ebc883364"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgopeed"
  end

  test do
    output = shell_output("#{bin}gopeed https:example.com")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath"example.com").read
  end
end