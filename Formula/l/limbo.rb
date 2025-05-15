class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https:github.comtursodatabaselimbo"
  url "https:github.comtursodatabaselimboarchiverefstagsv0.0.20.tar.gz"
  sha256 "1b5bde3f8ee0a5ea54eb33dea27df9c86c8b226dec01d74dce62c990fe5589cd"
  license "MIT"
  head "https:github.comtursodatabaselimbo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151ce76e01f46e828b333da56e5120a4e10c3a027d4b49d53b4de714ee3a5247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86d6cab373448e8a7c3200633ccae438b49da6a72d8aa2d1ba6c6b2cacc4a731"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "189ddde739900ae00b7b95742167f5d69bfb9c3fa9e65d02d58a325920738bee"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c67d54ad8fa5c62511973d7f28b9601027872edd8c72e3188566dff42696865"
    sha256 cellar: :any_skip_relocation, ventura:       "d9eb614c8b11174ee05f49459bb3848f16f5821949c62c8a657b3d3cb6d9953d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f4094731275793859efdfacb07ef6f87a56690c015f9a4007010f2c056298c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f48085d8fb88fda947b9ed250c5ef42cfee504f1845eac283f082d1186cb3c"
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