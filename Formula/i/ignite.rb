class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https:github.comignitecli"
  url "https:github.comignitecliarchiverefstagsv28.5.0.tar.gz"
  sha256 "236a8c7ab1d7477f3e59c6dd857307044381d8a7257f38377876e6353b64d2d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aca55ee37df556df1fda06c6aba67ba70ae089f4872fd9374f4f7c0d08e56f87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3385df8c8393cc66eb604a72567cd38d50dd3d30455706421c0aff5f2c23392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dab20bdec38aa93918f6a8b103482eb878cc5501a3eea925b2d71fccf2932753"
    sha256 cellar: :any_skip_relocation, sonoma:         "decaa183fcac690023beb5f07ff08dca9b51606bc56adfdbbb44894aeffbcc62"
    sha256 cellar: :any_skip_relocation, ventura:        "3f6e3519458fe478eecc4bacb85a257bb72ae7ad311e6172e3691f1746362eae"
    sha256 cellar: :any_skip_relocation, monterey:       "dc4097be74ac209574894a152cffa39a6eafa03bac852cb8c900f23b4cc84b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d46bcb0260ca34ab9a93debbd27fbfdd4cf87aa41cfd731e3d108d35a559531"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(output: bin"ignite"), ".ignitecmdignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath"marsgo.mod", :exist?
  end
end