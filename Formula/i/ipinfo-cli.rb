class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https:ipinfo.io"
  url "https:github.comipinfocliarchiverefstagsipinfo-3.2.0.tar.gz"
  sha256 "997eff6e52c9adcae16e4f1a1c6ac33d0f971f61cf5959fa2d044d42069b9047"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^ipinfo[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c9d9166563933dc3fff2e409839952a0c5d9ed3d4a694145e8e96f1cf6f7b69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1909b291ea0e13bcb358ffcbc9b9a12448efcc24c3c05be21f007aa31b0d579e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea85b5ffbe2777806330e0be39d85694be325a123aab1c794416f7f3125b682"
    sha256 cellar: :any_skip_relocation, sonoma:         "4774ff8389acd984a674f9d704876082dbe8151011a128ad25a904d54b6676d0"
    sha256 cellar: :any_skip_relocation, ventura:        "2bccf0dfbe19237df737573449a05a63f55edcdbb21d6a32652aab6b3d61d641"
    sha256 cellar: :any_skip_relocation, monterey:       "11250b402b87be6ae093d008f8bd2ef222f77ef0949684c87da533d6de97ec94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e28cc93a4203261e790e742820fb4a8830f8e048d5e988cdc58f216480d7dd0"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system ".ipinfobuild.sh"
    bin.install "buildipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}ipinfo prips 1.1.1.130`
  end
end