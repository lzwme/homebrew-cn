class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv1.16.4.tar.gz"
  sha256 "a312927d4d725d12f7f00593177f87764f0670e8e41b3844d2cbe16cf647da58"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad39986dbdb1ea43db0a6a21955964227204e0d62ef2f3302b58008a1500d0ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cdec13e743bc92829a47b56463561ef915fafe555727c170feac23fb43cbc69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b64d8214adc87375ac66427649b42762e43d839a2b916b6a1419de8c041692"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd602fec226ae281f86548280516d0d3003ef2a4cd333e7567feeb4119b60a2c"
    sha256 cellar: :any_skip_relocation, ventura:        "9a676c02179dfe69fe2b6aa0d9113726b3d674fb84867b95aa84f7ba39abfa59"
    sha256 cellar: :any_skip_relocation, monterey:       "f4073a6a3b1e9a36d8925d6840c756e29edd77d140c0c43dca31e7d123677e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d555e9df2da497fe5566d6f5cd8734d1266b841c12e5301e5c675bd4fdf0bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end