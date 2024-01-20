class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:github.comreplicatecog"
  url "https:github.comreplicatecogarchiverefstagsv0.9.3.tar.gz"
  sha256 "bb3329b6c7daeef166501883946231a58675770ba624e1450c4be00b549be77a"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c25b503f59a6d9eb47ed15ac4961c6c53b77247e813baf157532a6e95f39b4b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4a922c4b4e78147490ef64d68e3a5f1b3767c319d1a47897f917d6415ec5812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c20e368079b7d1e872bf8dcccc680a39b129b35f91ef26eb8accbdae729ec5e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dd4b16074ffb703694bced884a52bf57410b845c2f07572306e7f8357b21143"
    sha256 cellar: :any_skip_relocation, ventura:        "dcb0391e7169371a3eeb53bb263f80b7a6369fbb25a8c39de4b67444d65961c7"
    sha256 cellar: :any_skip_relocation, monterey:       "465b737cae6e34253f225d9a95812cfbab7a71aaa3e655d6e0c3694767de1432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aca20eef92473218598035ea61af0992d87410d4687f96f65e464a1d43fb595a"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}cog build 2>&1", 1)
  end
end