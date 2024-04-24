class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.57.8.tar.gz"
  sha256 "d625f3899bfe381731c3209e8fa8e6304acda45b0fe1acceae242d07800cb560"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b65cd920d9262e132b7c0b751d2965a5e1d7173248bb00410bce58f90ad2443"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42e6115d37f2f1ba6eb8d7ede81eeb37cbf1fdc84465fe4c3146a2cb5144575c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62b95adf4ccd282cdb4ad88bd92baf04c6cc10d16132f69753a24af5b0cb4af2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e897f3b4b62831f5791c9b63d459017f6096d7b61c06a1b0e301a071e7bf8b6"
    sha256 cellar: :any_skip_relocation, ventura:        "30536ea493f24d1202122fa234fb82423e8facfd1365cb551a208142acedd9ac"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd0e73d1f267e41cf5713e9e2e447327897687d3e0f216bec65d828ccd6ba28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc25fd4a9cae4bb509dedaed268562dd705c6e8447feffca5bb9721f53faf814"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end