class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.9",
      revision: "5b3eb661e594dcc79152d94c7cca97d4a66ed133"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af90f18b389d9c11f27ec10afabcd03a90ddc0d79690f7d3074a6573011eec0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00aa912763aec30f0378d1a315843f7807fe41fd2ad77eea01a74d53cfa3c77f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ee29be63702a982d3022b0ae79e255730a2edef35a0358c931e71921eb2e9af"
    sha256 cellar: :any_skip_relocation, sonoma:         "658863d508cf78c1da15534ac501e9b5efccfd42be7f068cd4b5967469028c05"
    sha256 cellar: :any_skip_relocation, ventura:        "bc43fb1326c3527cf1e3fc382b6672e55e1ed464f51712e3d937d7c46e557481"
    sha256 cellar: :any_skip_relocation, monterey:       "fd71f20e245e6ae870023f3c7d34e085dec6061a8e9121dd7e1a2c21e346c8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3233b486678f04b943cd59eb933f27590e0879b6518ed2a3c29486fae0d09059"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    system "mage", "build"
    bin.install "cartridge"
    system bin/"cartridge", "gen", "completion"

    bash_completion.install "completion/bash/cartridge"
    zsh_completion.install "completion/zsh/_cartridge"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end