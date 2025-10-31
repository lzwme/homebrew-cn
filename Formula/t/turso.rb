class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "ac49972d591341d6771de03d04890d631bb3ee5e1d2ec14931351bb7fc1acdb9"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f339d6cf41a305f8e8dd3181e76cfd7c8e7f4af03f622562a4af2df66535e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db91a2c16693cb4a57bb7e7e4a6379c91df8d6c15e9a5c9bdb8e2e85e8ab24dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce413b4505d3680c06be692ce36a76fc7601611e25d36cf9f2b301e45bee4d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbca8788ea4361541a493875d326b432ef6b753e4a77fa8563df73fd6d41f73c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72378ab1c644eef14539ec85116362f6c63ce681f97ef864ce545810610fd4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a35a5bfdf61f934e77d03538cbd78e68e0faf175e9cc9f7360810e44f1eeac4"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  # Fix to error unsupported option '-mcrypto|-maes' for target 'arm64-apple-macosx'
  # PR ref: https://github.com/tursodatabase/turso/pull/3561
  patch do
    url "https://github.com/tursodatabase/turso/commit/0ef0c7587979ce3f6863599e387c9ef6e93abe75.patch?full_index=1"
    sha256 "788ffb4a456318a16073784b940fe6c10376dc54bc4408ca6d55db068b888303"
  end

  def install
    # Workaround to build `aegis v0.9.3` for arm64 linux without -march `sha3`
    ENV.append_to_cflags "-march=native" if OS.linux? && Hardware::CPU.arm?
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    # Fails in Linux CI with "Error: I/O error: Operation not permitted (os error 1)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end