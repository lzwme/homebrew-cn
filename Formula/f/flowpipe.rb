class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv0.4.6.tar.gz"
  sha256 "13d907232ebe5d40886010938fca510888710abd7bfb88c2f51ecfe0373230c5"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aad1b9928f4d7a3ee7bc882922c7e792dc04f46d1af7f3e1fd11998d119f84c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecf9115f8a797bbef014aaff051ef88f5a33b7dc1ad83cc2c3836dabda557ef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "997b977d6bcb2ac3d6ca5aa7514e62a7055fb51d4d52855a246147a90c811eec"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7fb23fe1eebf6924d8b81f54075da579150fb4d93206c5e80d8bb3207551bf6"
    sha256 cellar: :any_skip_relocation, ventura:        "7c81173319bbeadc14df0f7952b1f89d34bdfc7346c2cc70546f55bf0c21c5be"
    sha256 cellar: :any_skip_relocation, monterey:       "0042336da86926976ede466388af519b5b9dc214f31229b789b119c1d3524b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "330c8c6629ffdb995c0a95e0375f8d9cbdd58c76170b9eee9159859c2d891583"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "uiform" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}flowpipe -v")

    output = shell_output(bin"flowpipe mod list 2>&1")
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end