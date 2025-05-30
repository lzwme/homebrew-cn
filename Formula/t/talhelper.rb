class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.27.tar.gz"
  sha256 "e98d0cc0bbb5852c81fc220cf30b01535abf54fb48dd77edce201fcafe8a41de"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec31db6ddaf231407c301db2c3278a1ff7d03dcd98e25f21c8cc19ad102f51ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec31db6ddaf231407c301db2c3278a1ff7d03dcd98e25f21c8cc19ad102f51ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec31db6ddaf231407c301db2c3278a1ff7d03dcd98e25f21c8cc19ad102f51ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "84cfec72966bb834c526fda79bf4291b231045ad28b08722fe43f2321ea578e7"
    sha256 cellar: :any_skip_relocation, ventura:       "84cfec72966bb834c526fda79bf4291b231045ad28b08722fe43f2321ea578e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b3832fb8d4ee327096ae6ad132582000f76d1f67f06e5b0de485b3d23ea99a9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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