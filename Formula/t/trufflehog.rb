class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.85.0.tar.gz"
  sha256 "6c1c18e24d9497b6e34353746947613e86324cdbcc36d685be8bf9627ae8f054"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d27d15f7310378f32c1c1819fd6f021c3f6b54bdfb127665a619e8ca55b9d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2a61fe35924708f48d33ca67c384e2a490e34faebc8f9714ca24e22c767e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb723ef3c2b7ffc3c039e63d8eee4e02bb835704603a252a00640e5a18523745"
    sha256 cellar: :any_skip_relocation, sonoma:        "95dfc5695e548203f1ef1dc31e1bbb6ffd9801e96f79b12ef0f62dde27a9db16"
    sha256 cellar: :any_skip_relocation, ventura:       "4e3f97b44df2623fbf244e873beeeeff154e80108852d75f07404f891715cf3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0159092253eb4bc8007b7b3af58577481df5d28777b23f67567d79029105d6b2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end