class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https:github.comraviqqemuffet"
  url "https:github.comraviqqemuffetarchiverefstagsv2.10.0.tar.gz"
  sha256 "95f1cbd3ada8807a9da23d0d4270a37510a7713488664cd60a8e841f55d9ebb4"
  license "MIT"
  head "https:github.comraviqqemuffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54b048524e6471a8b510301771dbb09cfbafe5fb19500f2244fe4502ca3fb1b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8b7c7c9f2bca07873721be3639b42770dc0708af4d16c4b9d56f923ed1e0710"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36d42094b3129207e2944a85aadf4a54b695937c5892c0d1e1d51b2ca005c4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ae7ecaceced9fadf76839ad0e41689dddfc8d4b3519d794c9c69e8796bf0c4f"
    sha256 cellar: :any_skip_relocation, ventura:        "e1ee5dec04216de77883b707dab537fbc98cb0908eea2ab14d19bb6fad9fa3af"
    sha256 cellar: :any_skip_relocation, monterey:       "708a8c71633a14cff36d74fd2d06cb10390e99c25626fe02a1e449907799efa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4df1ac78a031e2af87945f038a5631993992ab70e90f93f3e90319f7643f5ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(failed to fetch root page: lookup does\.not\.exist.*: no such host,
                 shell_output("#{bin}muffet https:does.not.exist 2>&1", 1))

    assert_match "https:example.com",
                 shell_output("#{bin}muffet https:example.com 2>&1", 1)
  end
end