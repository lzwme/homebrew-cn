class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https:github.comtursodatabaselimbo"
  url "https:github.comtursodatabaselimboarchiverefstagsv0.0.9.tar.gz"
  sha256 "da3c86ff62604a5ca4b70edd9d6a0310cf1760c29128bce68ce8c01930e68a4e"
  license "MIT"
  head "https:github.comtursodatabaselimbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9266916800210d2d93722706d88e4e570c0c4531e83298cc80993b583a7334de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "459a4450bb7d62c15f0aac3bae784c568406d425661fe5faed5f7803fc66bb3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d847af195a324571246a0ff63a2640aad24988df1bbe155ac689d50b5c775520"
    sha256 cellar: :any_skip_relocation, sonoma:        "008efdf31fef9ba4e2bb504942e2bad808ba37a4320d3917b1ed74388253d712"
    sha256 cellar: :any_skip_relocation, ventura:       "640960c8039268417b1c3a50264aee8465f74c178e5a33103e6136070ea85285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8100fd269e3c4a7c18daf44bec06dcebcd4821f417b92e78bb60a7b200abca40"
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