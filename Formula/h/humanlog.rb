class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https:github.comhumanlogiohumanlog"
  url "https:github.comhumanlogiohumanlogarchiverefstagsv0.8.3.tar.gz"
  sha256 "633328ea6034a8177b237ece6a45055ad0c13880ebafff0e5b72fa0bb5bc58ba"
  license "Apache-2.0"
  head "https:github.comhumanlogiohumanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81bc82a65c08dc26184ffcb50df6832255f129a6e77670c78fd03a929425ea5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7539c48d0d45fa43a0bd41011cd86ffabff40cfa4499db493d85d6257facd07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "940482b26b4dec7029114f3fa253698260aa3e293228cae08f1d548cbdbc8562"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b432bb1b21cb60cbd3bc850c3d8551e6a04e44d20a81041fe6ad1fb20f6e138"
    sha256 cellar: :any_skip_relocation, ventura:       "4ae763d5c2c0a8b564907400ec1b776b7eeb89a4790d47c32d6c0520f614f74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1786665f6b6ff12b27e78a8f5c68a396d2b19fe8a2a8296e7d27057cfe7830f1"
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