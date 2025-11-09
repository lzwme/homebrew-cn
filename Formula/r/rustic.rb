class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://ghfast.top/https://github.com/rustic-rs/rustic/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "efd310855d44758ed0e3cc4bb51ffc8bff59ff160c942f46988f03ef978764cf"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae26fd8dd989ecfd1b4744b99ba12fcb688ba2bc6e1494e15688d32fa3df7068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1d1cde7b016b59f21ba575d3083c6896ec91d15c03a359cea47d0ca6d85468c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d801e31ee5d345b0759ddabfb82a5b64996fce97c6d9baa5e5d537fc1ac612f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fc3312f74d933cf0b184355c6464040e561da18a3915a55cdd5257a5879248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52ff58014c7588e4829f7a8e46a920c19389d086e70b5263c8d7ba303e10c03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ada87234d02a89303edb10408a702e3e9d28922361c9d102bb7127e335b0567c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rustic", "completions")
  end

  test do
    mkdir testpath/"rustic_repo"
    ENV["RUSTIC_REPOSITORY"] = testpath/"rustic_repo"
    ENV["RUSTIC_PASSWORD"] = "test"

    (testpath/"testfile").write("test test test")

    system bin/"rustic", "init"
    system bin/"rustic", "backup", "testfile"

    system bin/"rustic", "restore", "latest:testfile", testpath/"testfile_restore"
    assert compare_file testpath/"testfile", testpath/"testfile_restore"
  end
end