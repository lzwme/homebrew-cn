class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv0.4.3.tar.gz"
  sha256 "c1482486ec7d4f026f181eb80c0e98be02ab10e716f98e91500153678dd909f3"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a397b3532f4688f6d59a07d97fdc2420d80f282e7df3ed2e9685c2ed885eedce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "565888172cbf6099cecbdd8c13e6c8ec6f0a0b155902402534cf7b1504723c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6326a531fae03e31d8d2ebdd21c15479e873eccd7d2a5072d202fcb73cf55ac4"
    sha256 cellar: :any_skip_relocation, sonoma:         "198e6d2b833130b0c11a5df25d912167f0a622478426a7c368d7d4c3f1f7dd13"
    sha256 cellar: :any_skip_relocation, ventura:        "957249fd42237f064e8ea4803e3532f9780baa8bc6b4387f3c62810b64e3c015"
    sha256 cellar: :any_skip_relocation, monterey:       "7e764add6455ec5ce028c34eaa0b3b47d5a8bb887839f90d3795d5abdce551de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "202d9bf3f02727d6e098fb6c7656079d0602b40e98d7adf8fa3884ab9041e8a3"
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