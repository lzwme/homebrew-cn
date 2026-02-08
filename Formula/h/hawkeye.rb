class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://ghfast.top/https://github.com/korandoru/hawkeye/archive/refs/tags/v6.4.2.tar.gz"
  sha256 "e2225b323d971323d1e4d3d33331914ed67998f0f7e6b0bc0297fa3bbe3dee6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd1b86ff480014200a96611bbcd4fd6088355b6ea16f9348176dc85fb9af311c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d56d14f67686af737e23b0e67de714770f9d4deafb70c94e1674eff94388ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91f2e0fa465756622d8ff6fe49d6eb38c89c95841fdc0368a97c6088c935250"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8a7d24eaa16b548e3c231fa5ba0596e78a2aad1f24e1f34533f5d889d07193e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e633760b1bc677b3ca192e2abe323dc82c18ca439523bbd9add03a3dd6356dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e396a7b87efb9e6b5470aa10744d6ccf4c1f4d37ebcda57fa900c01b1d0625db"
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