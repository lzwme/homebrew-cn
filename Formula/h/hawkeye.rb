class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://ghfast.top/https://github.com/korandoru/hawkeye/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "7a6af78223142af97da040362be4e3b26c89fab19d5aa3a5fdfe68d43a469588"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "829d78cf2732dbb894afe5e1bea3244084d7a85be257d70ddc1f2f71a9860e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32673b875ac7de2aa974580fb8825ba0d8de73cf4e7c40664077e76ec7ffa9ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a3dc1e0986efe0496c66ae3366757bd64bc9f2b668f19d6abac93916937d44"
    sha256 cellar: :any,                 arm64_linux:   "a030f53e7a328267d4d374166a73ec0aa6c572b39bde3d92376ea3f0b0487c24"
    sha256 cellar: :any,                 x86_64_linux:  "ec03b7e063d217bcb1af54410a6706deffd400871cd3020fe9dac7d7594fbee6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "hawkeye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hawkeye --version")

    configfile = testpath/"licenserc.toml"
    configfile.write <<~TOML
      includes = ["licenserc.toml"]
    TOML

    assert_match "unknown field `includes`", shell_output("#{bin}/hawkeye format 2>&1", 2)
  end
end