class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https:github.comtursodatabaselimbo"
  url "https:github.comtursodatabaselimboarchiverefstagsv0.0.10.tar.gz"
  sha256 "39dcc309c12c7ef496f0c7d2ceb3a6fad7c2d35b7fa4ce8df8077ca8bd781bb0"
  license "MIT"
  head "https:github.comtursodatabaselimbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a577a88feef349e99e191bb65413566880496480865c24c88fd229cf5e68ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158856a29565ac83dd1ff21b25d84da9cadfce89027ee11afffac7f202a412d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79c226401b12ee0fbf13073ce1e766fcdf550387919d6800e8579780cdaf0c0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7df758c6b23455d8d09167d2d3e8b17819aa6f5a64b959064bf565e217e4f70"
    sha256 cellar: :any_skip_relocation, ventura:       "b26d316ef5124c999271eb676dbde6bcecbd8e267590bb1fd160ef6abb693c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb501dea6cbc11338e5809a8ac4a24d63b03cfe2ecae23fba56beebad6a09d34"
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