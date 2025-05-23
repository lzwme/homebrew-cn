class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.605.tar.gz"
  sha256 "f05d8da70ae783d9610450eb0c2519ee1180956c61345a84bf82e5d861271f61"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4caf70557144dfeb5f43aab983dd5c586ad300917e1bbce8b2153ed61d0c51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b2584009a7dea8f1e1a8901431a886cc18da00728e1a5cfa6167f666eb32c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4a6253e86520e377bb7b47fc55836c28387e156b611038bb08d945578e0f1c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4111e943548eceabc96971455a02c5c9b4ec53b23828c36cdde33a83dd76d7a4"
    sha256 cellar: :any_skip_relocation, ventura:       "8d521a647b8ec9730a02cb03ebc516d4751457f72b4b5472e9ce797f830748e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f20cf0f546ee66d348d9995dc112326175e8959b30930ce861160c9aedbfb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0afe1dd3e0604cfc951a503a76a6c62c10ac428ef31fc50fe2c2f746860d8f6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end