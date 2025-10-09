class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "88c8873736180be828c56c68e055778c88be389c812c1be12898bd75cf3c3b2c"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7fd49c4c881902c77b80524ee00d049cb990c9925a110949183207ddaef04ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98fb9f9ada73c2be61d4de6ba43c149931d4a2790228b66013b5604ce1e7a3b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781b25e3d389445589819c1801fe7658b19d24559e008594e5b67a1d05972291"
    sha256 cellar: :any_skip_relocation, sonoma:        "34f33c918146ee71c52aedf033870298863515895114d0a2609f9fdf5ecf92e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e66ec51d125b814c84285113d7fefe549c68b3c24496f0ebb0c9c3881ce4b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d9092208dae26d495a8c9d1eeca817000b176ce23ebcf2865753a0170414a84"
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