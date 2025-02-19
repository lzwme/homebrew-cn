class Limbo < Formula
  desc "Interactive SQL shell for Limbo"
  homepage "https:github.comtursodatabaselimbo"
  url "https:github.comtursodatabaselimboarchiverefstagsv0.0.15.tar.gz"
  sha256 "d67023b0ca634b15c74427adb1d69b5abb3b56ffc107d5a39f69a25f01de5c14"
  license "MIT"
  head "https:github.comtursodatabaselimbo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5266f19688bc708d442e25c8cca803626748c0f8ea14e26f36f4e023007c61e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb5068167c93b990ff952379d780db00c1a859e422964826346bca499dca787"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44d221952e5affdcb56eb0307f33a836a87d8b0adf256a9f9512e3378a23beee"
    sha256 cellar: :any_skip_relocation, sonoma:        "53ccf496c7ec539b88ab6cef4ee6a3cb7c166de20b75f8920e27041c8025afa9"
    sha256 cellar: :any_skip_relocation, ventura:       "be74107b74f4861ef987d8ed39a98bc20963658958826ce212aa5f11688c9320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "722ec9ca8ce4823ece32769fa37874117774b2e2607f640cba253d5d9222e0ba"
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