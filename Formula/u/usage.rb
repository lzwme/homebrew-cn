class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.3.0.tar.gz"
  sha256 "d5f28c4256b8ffe5dc677a4fa2cc9fcbf6f514724e5debb9c70e01d60072dd31"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49dd2eb292fd33f90a8ab494393469fc11f501d9822ec46eeb51f47d6c53be39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e91bac8e4f29f108b187c3eabd970c087d3af10a3d787426d14127f5663eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "668fa2b8b5c8e15cab43b4ed28a7500bca5222cc7bc79d687b75a128c20151a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "24325653cf4740c4fa6870afe257342166b9f9d6b89055bb3b9adbd8931b8e77"
    sha256 cellar: :any_skip_relocation, ventura:       "c108d181111b6d361efc2eaf96158da7197d0a22210df0698e80927dc80d4a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7194354dad6b2957abec8805ebabca5ebab74252ff4ce34dda8c02a9cc3d3a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end