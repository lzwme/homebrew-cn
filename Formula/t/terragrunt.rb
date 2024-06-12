class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.59.0.tar.gz"
  sha256 "ab4d81f064eb999bc93843a72cb3819bdd838e3bd859652edba19dabe3fc9c89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ebf44ed3d3c0aaf2189795bb2c2558a83fa9622a3457fd63c3366a2707a7d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe68440cbde1481d8ab563fb3e13fe0d430b6cb6c480cdd9c38b9c61f7f70f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0650dff995890983332cc0117765d1096870244d3d31ada099b948fe8a8e1b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1940eb3791426f00845e2b8c264bf94ffed9974aaec587c34fa594681791ca59"
    sha256 cellar: :any_skip_relocation, ventura:        "64e183e0dfcbf358c92be127f9d7e7fab8a68c7836ba22e27b4d3a654b825d53"
    sha256 cellar: :any_skip_relocation, monterey:       "dd57672326da9b4c840245464862621a07a2e31f92cd50a653d56859f89fa9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca069899f9dd2f92352708901f91ddd740883a0f5ee907c4f62307bb75e621a5"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
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