class Nomino < Formula
  desc "Batch rename utility"
  homepage "https:github.comyaa110nomino"
  url "https:github.comyaa110nominoarchiverefstags1.3.6.tar.gz"
  sha256 "12e14d951b3fa99d17b9a0de97b7f9d9003f67ef83eb6b993623da066bc54dd4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyaa110nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63d5b037e962f888090f398505a403fdf1a330823b5cab10b47438460179a0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8b845046c631d50b4a4119dd9a59421338bd1eca5f6c56b344cc8287970e8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84440c2ac0220f0e8c971a0e0de6280b47d87791f2b5fb79151de71e4a73b007"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9570c41100c0b24ddfb08cb703d3015c526cd7b939178d18463b63ecca98992"
    sha256 cellar: :any_skip_relocation, ventura:       "9ece1146d93c172619b4fb5ba9ec005e1df3cc5dd9635082a9f7c4d33f45ed38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbd2a5ddc584d9090937df634f0aa5cefc6d5bac8b1e8d50988ce8ab82b6912"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath"Homebrew-#{n}.txt").write n.to_s
    end

    system bin"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath"#{n}.txt").read
      refute_predicate testpath"Homebrew-#{n}.txt", :exist?
    end
  end
end