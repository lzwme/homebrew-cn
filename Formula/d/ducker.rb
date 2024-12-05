class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https:github.comrobertpsoaneducker"
  url "https:github.comrobertpsoaneduckerarchiverefstagsv0.2.1.tar.gz"
  sha256 "47c8ec1ad253e530f3cc858dba94b52607beae547a6892dacd43b0bdd4a615d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75338a7d36317802049041fe007a53548404093592e40c94f519eab84203c3c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0019bbcdd1ff12e0f45b18531730d40701237d8503ab64ec2c9f43c79f992236"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ddc2c2a34620a53065bafafe5759817f872ee804e6dc34d58fd263959d1e7a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ae1d86249b730a91bd7a5e53abcdf40d26cf719ecf4ba4b430fe118cb90e934"
    sha256 cellar: :any_skip_relocation, ventura:       "c3183514f4da7b096725d4164ebed3149cf661d02972e38d7156f1b47670d10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dde4d6c475f895c0fa6316f015186ba610daae9642c0c81747b4e3d44dab43e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}ducker --version")
  end
end