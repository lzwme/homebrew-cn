class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https:github.comtursodatabaselimbo"
  url "https:github.comtursodatabaselimboarchiverefstagsv0.0.12.tar.gz"
  sha256 "a039a332969fe7dd1c4d2e1b11c8ff9fa087cf03f4e2897ff8f158f1ed34f424"
  license "MIT"
  head "https:github.comtursodatabaselimbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80598359b24b02276b1607306aa683577ff8cc77c75dc4b763501c3f3cc9fac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87a010788cc4e5599de0354e444472fd75af5f371d77d4f6c198986e23594e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3daf5636577df1bcd36635d507a4b930cb1e0a9bbe187a466ce75884c90e467"
    sha256 cellar: :any_skip_relocation, sonoma:        "321e5984d613983c89f7e2f7274306d3a34071fd6477f2c4f938fa51789a81e5"
    sha256 cellar: :any_skip_relocation, ventura:       "c381670742085a5c9e070650296e9876e7207dbaeed42473751b5bead8bfe55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6bf60af1bac9e5d11f4523a30cdf3a587bb3a08f6241eafe7fc9195796a440b"
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