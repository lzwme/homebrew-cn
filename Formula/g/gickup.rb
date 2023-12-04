class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://ghproxy.com/https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.23.tar.gz"
  sha256 "819c43ea8d9b796d81f80ad76644fcf2127494435a4917bb4021448b81fc1bfc"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "404dcab1c5989074a411ce32d6cafbf159269a6a1c95b413ecb28640fbc0ccac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b849535adb2db4c6f6b482e626b2f709877236c07e038c55fe2382387929a26a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78221ee5b321eeb1c175bc330746dc1f1868e89fe173915deaac056a9ba15ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "624d50c3c98767fa9f7b01878d4f0d3e6ba5b89e1531750d31a9142f037ea59d"
    sha256 cellar: :any_skip_relocation, ventura:        "a8cd808766662364c6819642c27c1898a74c0cf8f8b69b7d514a86f16e528b6b"
    sha256 cellar: :any_skip_relocation, monterey:       "dcd9faabba552212aea210cdc6c614a2d1788ccf1933dcf978909b6a7883dc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dff97c7250f42ae677d1953037b742f5bf90fc7d8e0f84834b71bebf1f200d8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end