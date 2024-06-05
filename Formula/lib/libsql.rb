class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.13source.tar.gz"
  sha256 "608e2d466dd5eff2e91d3feba1de20743d232cd820339c0c28ce85be2506e7e9"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04725bb5146b95da24c20f568a3e9341a5ddc3c233c7449bcea344c4721caf45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "893e8f4068c8350001a0647dd6f32c3b145581012cdc4c7f9f8361316b364a7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b477058116af22875e3492b62515a9de04d3ca6d5e57eeb15aaff06a973969bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "f97bda60f0a4bf1b57d25216fa78ec2a6aeb649429546d6738a0d87c38f1a5b7"
    sha256 cellar: :any_skip_relocation, ventura:        "59839c1cac400b242cebc65defab7cc92dc5b9923425081829d86dd20794a64b"
    sha256 cellar: :any_skip_relocation, monterey:       "f209e3e4cca4d0e9f45b355d798228c52f7bf7838c62bc54f2a377eb0a9d3145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d19c92ec469da6e8862424a7f3709b94be8de1bb673014aba78d687a881438"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = fork { exec "#{bin}sqld" }
    sleep 2
    assert_predicate testpath"data.sqld", :exist?

    output = shell_output("#{bin}sqld dump --namespace default 2>&1")
    assert_match <<~EOS, output
      PRAGMA foreign_keys=OFF;
      BEGIN TRANSACTION;
      COMMIT;
    EOS

    assert_match version.to_s, shell_output("#{bin}sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end