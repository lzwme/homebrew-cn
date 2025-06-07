class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https:github.comkorandoruhawkeye"
  url "https:github.comkorandoruhawkeyearchiverefstagsv6.1.0.tar.gz"
  sha256 "8efc33b1cd98fbfc685d962c433617f9c6e88e22457e9e8120bb658e1b722341"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d7fb1591f035469c066aeb988b0b67fdb5252e615c6d4ff98f4c580e4986caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b84760f8b45fb9149dc6d12eba1b71db59828c157b41eb3cffe631bf34b30e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b5a09cbb8958b58e371ea5326b56a5335ad151a81f295b85928a5fbc771a84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e782ccbdffc0511f0c66ae3b0075b7599842a91cf29d5b729d89ab8fa5203867"
    sha256 cellar: :any_skip_relocation, ventura:       "ac75de60f733e185154b89003ed74cdeaf1eb9aec3f03967a94904cbf0ba7795"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "686ae29689cf27cd3e4e6d8887d0db5758046eaa5b872f62c4e1b3074d90f802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402d14d41bd94aee1af44de19ae5c483c9a9c0293d19d643d9921c377edab9d5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_includes shell_output("#{bin}hawkeye --version"), "hawkeye \nversion: #{version}\n"

    configfile = testpath"licenserc.toml"
    configfile.write <<~EOS
      inlineHeader = """
      Copyright © 1970
      """

      includes = ["licenserc.toml"]
    EOS

    shell_output("#{bin}hawkeye format", 1)
    assert File.read("licenserc.toml").start_with?("# Copyright © 1970")
  end
end