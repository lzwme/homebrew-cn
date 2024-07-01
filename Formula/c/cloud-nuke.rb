class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https:gruntwork.io"
  url "https:github.comgruntwork-iocloud-nukearchiverefstagsv0.36.0.tar.gz"
  sha256 "d77725ceabf2305c50b88398af91bae560e29c66982fc64e3bcc2043d2b2bb87"
  license "MIT"
  head "https:github.comgruntwork-iocloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67cf8656c0ec13ef6cca9fc8fb7c35fee25aa7028a2ec472a9c22df7de495579"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0bcd0e678f1b86de35efc6c5020ba6fb6b38901a4ef53e4ab301b193b90c208"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db60618a49130910847924d558df300b97ceb763ab858c6a2f091986c6df92d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfaa9520703ad9b15458455c40b5d998d72c3436161ec009e906f7ccf5e97df0"
    sha256 cellar: :any_skip_relocation, ventura:        "ffe0eec5770684b1e5e12c1dbb1197fe32aaa5f829d0e3bb8b9fef3f20ec606c"
    sha256 cellar: :any_skip_relocation, monterey:       "5b57dc0fd7c8c0c45b2b328c8622f42275e6ea147fcca67b51c9fa10c6ebb9d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dafd821e6ccc3374fbc17fed56c7630e5fd7e4ac67ce579740cd21d8d3773c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}cloud-nuke aws --list-resource-types")
  end
end