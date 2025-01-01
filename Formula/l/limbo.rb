class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https:github.comtursodatabaselimbo"
  url "https:github.comtursodatabaselimboarchiverefstagsv0.0.11.tar.gz"
  sha256 "901b56096601153346c33036420c71118b9a943f4331efcd4aebad4cbb1380c6"
  license "MIT"
  head "https:github.comtursodatabaselimbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6908c7394631b5088b37a0be2a685819b066c24a465ecb8073afdab41a036b71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c021d0d53468de6e29948cba04fc8cd84fa9b4cebf92800223c04b62b849c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7013d9169ef794fdd7b44c19567187aa68e4bed40234a6a9e9b5d7f122500fa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "703ad5f904628c3a5f1ed783224ab205d75dde8b28eb87294d56fbb45f3c287d"
    sha256 cellar: :any_skip_relocation, ventura:       "e5fc640066c6abb9a3f3479f13c9dfc99ae655ede0c148d883a64a03d6495a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8086e7f4a16e2d6c63a09864753dcace3c15d93be56d12bf34e63cbf8ee76ed9"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}limbo --version")

    # Fails in Linux CI with "Error: IO error: Operation not permitted (os error 1)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath"output.log"
      pid = spawn bin"limbo", "school.sqlite", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end