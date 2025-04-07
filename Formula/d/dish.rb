class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https:github.comthevxndish"
  url "https:github.comthevxndisharchiverefstagsv1.10.3.tar.gz"
  sha256 "81c4e7c883e109ce09fa02a4cebf99d148570f906f2c603b5fb63e2a2aff7b2b"
  license "MIT"
  head "https:github.comthevxndish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7cf2bd3ad68439493152b546de6d9215fabf1c5f1b21666e11c423a248d2c65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7cf2bd3ad68439493152b546de6d9215fabf1c5f1b21666e11c423a248d2c65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7cf2bd3ad68439493152b546de6d9215fabf1c5f1b21666e11c423a248d2c65"
    sha256 cellar: :any_skip_relocation, sonoma:        "e52763ac66b185f034abe42f9d965363b32dc221b4d126a5589df42daffb4026"
    sha256 cellar: :any_skip_relocation, ventura:       "e52763ac66b185f034abe42f9d965363b32dc221b4d126a5589df42daffb4026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11d750173a9da85ac43da4b3d8c976ef95e1dce98ba24ffbe719dd8de043079e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddish"
  end

  test do
    ouput = shell_output("#{bin}dish https:example.com:instance 2>&1")
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end