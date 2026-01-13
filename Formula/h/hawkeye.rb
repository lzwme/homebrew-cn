class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://ghfast.top/https://github.com/korandoru/hawkeye/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "04556d69eadc502cd9aab0b591f1cd996aa8cb699ebafcab362ac598ae4369eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "518c539f55042b6a6e16a97dbd43a1fe9bf946ee1d969b3afcca728fcd682e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47982ee37d2d1e1e56271c5bcf24a9f96320ebc96bb9c826de229a7a451e8b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63ed42b01f233b25dfc35f983813603ce3113e365cc666e6588190d46e4a323d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb627f84ebf00eb082f8eb2cdb05f22870a7495492e49928a12e21eeb858676c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2131c8ab7fbdb9de70b6c8bc8c846d94fcceb76065e409e62d2dcfcc8e0e6b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565d02cd592f2a48ea232ab0c272a16cb878941d42056f54b5ca131be5e110d3"
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