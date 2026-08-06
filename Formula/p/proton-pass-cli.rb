class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.5.tar.gz"
  sha256 "45217cb726c9aa3ae0fa5b9fa21ca386ec2cd148884a0a9327b88877f8ac8bc4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4ed6b29681d74be66e93698ae78ad987b2ae39a4e90f12a084c500995c42e4d"
    sha256 cellar: :any, arm64_sequoia: "59f94cdbfb75c2cf231ac5b16895b36be75f98a49b55e006ae576f021268fd80"
    sha256 cellar: :any, arm64_sonoma:  "4e8725c775716a8a719731df28e474608f04555566e5de3c5222c7e6bad576e5"
    sha256 cellar: :any, sonoma:        "39955b8ac04e5bc92d25d10cb6f957bdfa631645a3884d0ba0b7f39114547206"
    sha256 cellar: :any, arm64_linux:   "96b34a00414f83889980927527a0f14fd46810f28afdd62948dc4e6b86540387"
    sha256 cellar: :any, x86_64_linux:  "f851351ffd9cd7e367bc83b173937957b6e705bf75f170f97cb787d15c0de307"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end