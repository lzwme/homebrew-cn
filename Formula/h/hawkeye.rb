class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://ghfast.top/https://github.com/korandoru/hawkeye/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "90269767690e2a5e654ecff5dafdc9e5bcf22f19b21e69e3a910f972dcfc625b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b236d29d0747c7e5dca2547f2d73fce414d3776e0af610fe9234484e22c6e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fce1107b7b0bfbda78a3d770cadf0a7f9f25cb44dff9848a2c977eec88f4e06e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "689012e0bdc498156e7c47c6c866c388a4378160153f4b85dfb8daf146312045"
    sha256 cellar: :any_skip_relocation, sonoma:        "62769e84e9ae5baa2462023c7a9b95a9c46658ba9162d077f2dcdd091106659c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47863ac10b2e0d5243ef0e4e11aa36595482447a22d8c4a82b7b32ba1595ba49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652b56b7e57b4fb1a3d9376cc97917194ea8710c206c4e9d0f006208b15b367c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_includes shell_output("#{bin}/hawkeye --version"), "hawkeye \nversion: #{version}\n"

    configfile = testpath/"licenserc.toml"
    configfile.write <<~EOS
      inlineHeader = """
      Copyright © 1970
      """

      includes = ["licenserc.toml"]
    EOS

    shell_output("#{bin}/hawkeye format", 1)
    assert File.read("licenserc.toml").start_with?("# Copyright © 1970")
  end
end