class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https:github.comhumanlogiohumanlog"
  url "https:github.comhumanlogiohumanlogarchiverefstagsv0.8.0.tar.gz"
  sha256 "6f4e818a8b5202c58219b048597b3328f47cad15aac3dd2363c583960b52a859"
  license "Apache-2.0"
  head "https:github.comhumanlogiohumanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb04106124f8d8799b89619780048e25fb9dd19eaa562ee9a1dced0bdbc9885b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a74936d6d9529b6ef45807e9dd8a8a708b0b5982f012d954b949c402fd13e93a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ffa394ad373bb2d44279736eff9496b1537554ad6c41fe1f374de8ff55297e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea3b5a94a62592e42a0015de864b515c07e9b2db1618a184c65018a7e0023176"
    sha256 cellar: :any_skip_relocation, ventura:       "4850db088f9ca0371d05d2ca9b5d588c8244c0928920fa07df921c1a16e17c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e198415bcca73b752d2afef32a780e48259906ee1f93476b2f9f93d64170be30"
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