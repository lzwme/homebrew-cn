class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.63.5.tar.gz"
  sha256 "cbc1f64587f1156499eedfc711b6e0fa0c4f1e5988032153275c8d2b250e2c9e"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ae9191833ea293e2e4d7c925dd2fa255c347050a834f7cdae0905cdaeca4857"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f679042708db30bc5a6da852b5408d93958e95b44e4eda289efbab43b213bdfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a431b8a406d290c031610baf45c6354ee60952db71cf81f51a3fd95c1eb4aebb"
    sha256 cellar: :any_skip_relocation, sonoma:         "67f6212792df8e18195adb44ee5502e3a74559013dbdbaae0fc3dff897564805"
    sha256 cellar: :any_skip_relocation, ventura:        "60dd9f34c187321dfbd442ab1ef3dae9b8dbc70011d53ee43dac896cea406e9b"
    sha256 cellar: :any_skip_relocation, monterey:       "6454d34991b0cdc80f102e86edd64ea232857e2cb477f15e5f732b1356e86399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec732965d0d504875b3574e13904967f24010858d4417cbaa7171973c26938d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end