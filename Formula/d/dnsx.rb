class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https:github.comprojectdiscoverydnsx"
  url "https:github.comprojectdiscoverydnsxarchiverefstagsv1.1.6.tar.gz"
  sha256 "5fc857feceac3438ab1a3d9a577412ad153be5206887d4396247f87939be8e9c"
  license "MIT"
  head "https:github.comprojectdiscoverydnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48bbeace45b889a2291bacaa84ac74c69b2303a27a6a1a6a10e8f47e5d4395b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "743179ccfd331b2e55dee72e0a408d7fe7a62df852ad45e428ab4a4dfa9755f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa1e3551a0e345f9230611c8cf213f18180b7e2ff177d65cf3a5dd6add9f4a94"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6a77ac14961cce7b0b7a2576e3cd09adb2b030a5350272d1bb6938f7e3142f6"
    sha256 cellar: :any_skip_relocation, ventura:        "f35fe51016343673c6a43d9e0e86b5ac2d2bb481b2d2bf779fe2bc1efe498916"
    sha256 cellar: :any_skip_relocation, monterey:       "d282fdea75c2eea93841c7d26e90c29b0a43dd34fb0ec880ca48668b9d68b9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc2fd2e568a6b208a2c24b03abff9cf6b3e99505d27bd7872631cee1ccf8e0c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddnsx"
  end

  test do
    (testpath"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}dnsx -silent -l #{testpath}domains.txt -cname -resp").strip
  end
end