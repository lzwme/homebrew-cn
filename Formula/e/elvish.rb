class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https:elv.sh"
  url "https:github.comelveselvisharchiverefstagsv0.20.0.tar.gz"
  sha256 "f0b144757af75cd1cac197210f54d4063379bbe76de6c10832085ae051ca8212"
  license "BSD-2-Clause"
  head "https:github.comelveselvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c732f3c00348b1e2049f51b6447cf8ada3c36b78c4ae9db6224acf8b7d6ec1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e68b09a27dc9d8ce8d562faa20a854190934db63a7fdc57e0c411519b9733cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e6e37cd88482926e8da9c47ceb8f0951b04c4a482624a375fe2416fc2ca973"
    sha256 cellar: :any_skip_relocation, sonoma:         "2566d7d4eb3d40445fe6126f6aba5bf7542838f1816e2eb95382d6d1f7f8a2b0"
    sha256 cellar: :any_skip_relocation, ventura:        "2697321fafbfbfeea6be5c29a679aa231403299acaffd90ab8d1bacdbd080122"
    sha256 cellar: :any_skip_relocation, monterey:       "89cbfda5ec9f497670ed5b0df9d5269215323d41c15442d8346c89c57cb4e87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d2e404ba0a4fa8f912e99229946fdad6721ab4b88d2d006a25bdcf83aab289"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.shpkgbuildinfo.VersionSuffix="), ".cmdelvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}elvish -version").chomp
    assert_match "hello", shell_output("#{bin}elvish -c 'echo hello'")
  end
end