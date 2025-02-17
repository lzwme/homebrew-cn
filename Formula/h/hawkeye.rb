class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https:github.comkorandoruhawkeye"
  url "https:github.comkorandoruhawkeyearchiverefstagsv6.0.1.tar.gz"
  sha256 "03b425499fc13eaf761cc99228bbf36b390590c4df2c17180e34aba6972a4282"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1cb9e7525712412dc496757852dbd5f1509f2722db668b0d8404185cdac483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6308ca11f4d2feea0b41c1f0386ad521822fbee3361f57a54b19a5b17a554db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a39f1ac34ee7209b1e3a837124722a6bc8ef217bf5ab57a8c7280579b49f827"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f66043a530471a87b6efdece21e15a14e4e8e5c4262b3486077b7a2f2f821c"
    sha256 cellar: :any_skip_relocation, ventura:       "4652884b9dc389fdc8ded65e244b3b58602d22244ac957d45f5bf3654b6c6add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0b70d0329e4aea02303090639ccf21041cbf08cda653618a71c68e50dc0a9f"
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