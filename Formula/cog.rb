class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d143f50bf601f04cbeca0693e436eeb9e7c706c6423a5e4647dba480a2ecd3d2"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb6efb436611440a87b06436d5bdebf0d9e39c36600cddadb852623cf238bc19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62f8d32bddb977a85a7c062deabe20767dcc7c73d499353eed6e5bfd28e4afc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a26d87e2906087a5f518f70d8a32c480db7835f88ac8e738b6b00a3addaf37c4"
    sha256 cellar: :any_skip_relocation, ventura:        "bd22592414e4d165c160d0f48309f9822c3b2223ff37a283d14226a65e6cffa4"
    sha256 cellar: :any_skip_relocation, monterey:       "41f522fe1ace8fd48b620d6738ac24c2ec0827b7c25a6dae4b689e69d2126a3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "96b8d7b99c27b14cb25c06dbc601010205a446b0c6d73e0083e132fb5bbf6ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4009a69718146b1dab87f9025d5434c2a90656d3bd117f1d34723274e57c3c3b"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end