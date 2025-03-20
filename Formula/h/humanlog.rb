class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https:github.comhumanlogiohumanlog"
  url "https:github.comhumanlogiohumanlogarchiverefstagsv0.8.2.tar.gz"
  sha256 "aa6914581f0e915dd435c382ea0d6b7f8af5c5809c56eab7c055fd290d58b689"
  license "Apache-2.0"
  head "https:github.comhumanlogiohumanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1859ca61c719de46d86671f86e4492923ce4d3ff3885dcdd2f6c2a52fc03314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b17bfb37b0572d75728742a0d82d8dbadc14c9f0d272fa050133ca0d1026d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c985427efd14fdb483f8a402efd078d6c1136876b7fa15e3ef95aa2ce4e3470"
    sha256 cellar: :any_skip_relocation, sonoma:        "895f896ef8590de90efd8f2a18c18f12336fb99f1b56e39ac5c8bb00268822ce"
    sha256 cellar: :any_skip_relocation, ventura:       "2e13fd7850821e7b6f8a1c1ca6d08a85066e58f4c431b4f6dc3a497855faadd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78fff43fea67cd0c161c45415c23d88ba0ec47f9ef07cbc4a3257094b56b483e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionMajor=#{version.major}
      -X main.versionMinor=#{version.minor}
      -X main.versionPatch=#{version.patch}
      -X main.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhumanlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}humanlog --version")

    test_input = '{"time":"2024-12-23T12:34:56Z","level":"info","message":"brewtest log"}'
    expected_output = "brewtest log"

    output = pipe_output(bin"humanlog", test_input)
    assert_match expected_output, output
  end
end