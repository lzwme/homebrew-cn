class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "6d46176813aafe125c8fe574748c846dbbeed459dd13d67e2d60f26a1422f143"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "812e4587d816c3b89ef40648bc64e9b96b3445c03d3adc1f20f4b7fbd63a266a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef47f9af5c9ede5de1895973a76b51d1734393c2b8f5869e58e4344c915a0cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a7b45e15025c331c228a4f43cc54f744cd753fb99a307b4f510cd201cf553e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "81a7d2877ad809be54204c2cae00fb838384c1899173d775d2199b4e3b652a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a25fcef5e4c50c1d023917088b4ee333b7b72c5ee9155903c59c65e355c9ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76d0f4713514e6a366e389fa3dbd85aad218a79c9282c44bd342792842bc011"
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