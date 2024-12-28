class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.14.tar.gz"
  sha256 "5ca1f0a938c8f7e99e50504c6d1b1e43a6c048fcd14a12f18e10ad4e023e44f5"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7091b1a591102cb5c8381d0bbb0c26f6ab4f28e2d1de4a1fb0ab4a20d4de33ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7091b1a591102cb5c8381d0bbb0c26f6ab4f28e2d1de4a1fb0ab4a20d4de33ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7091b1a591102cb5c8381d0bbb0c26f6ab4f28e2d1de4a1fb0ab4a20d4de33ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e4999112cf002bd5c54f1da172892a610ade336dafb010c9520d41d0722253e"
    sha256 cellar: :any_skip_relocation, ventura:       "9e4999112cf002bd5c54f1da172892a610ade336dafb010c9520d41d0722253e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd62ce267684588a297567a344517a47885c7900d2331d9dd3ece052294cf15"
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