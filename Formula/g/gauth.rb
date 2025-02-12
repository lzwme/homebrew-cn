class Gauth < Formula
  desc "Google Authenticator in your terminal"
  homepage "https:github.compcarriergauth"
  url "https:github.compcarriergautharchiverefstagsv1.5.0.tar.gz"
  sha256 "5c98287f5c209b9f02ec62ede4abd4117aa3ca738fbcb4153a6ec1e966f492a8"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d91ac9029a1df98f1c2a3b5318f364c4b826c3f267e8d420fa389b5fc536dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d91ac9029a1df98f1c2a3b5318f364c4b826c3f267e8d420fa389b5fc536dd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d91ac9029a1df98f1c2a3b5318f364c4b826c3f267e8d420fa389b5fc536dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e2838fc31e6a7dd13880b2f95ef69d7732e8db0832feeec7f30b6ec18354b1"
    sha256 cellar: :any_skip_relocation, ventura:       "51e2838fc31e6a7dd13880b2f95ef69d7732e8db0832feeec7f30b6ec18354b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f0fe17b342e5ff16879bea09f90bdf1ab70f33a9dea3b3ba9fbf3cfbf47028d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    refute_empty pipe_output "#{bin}gauth demo --add", "JBSWY3DPEHPK3PXP"
    assert_match(demo(\s+\d{6}){3}, shell_output(bin"gauth"))
  end
end