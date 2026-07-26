class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://ghfast.top/https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.18.2.tar.gz"
  sha256 "38023b1af5355f6a886e88d6f8616a1b8cb35ba88f781a07f816d1d8fa610ad0"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37e2de50c3d3216716e81d5f030823547dc8926bd1aad8c9b9b7909268e12f61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3dd79322673b37349b75750d06e2ce9eafac600531b143e330dc842ee5e3419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f98b0ea325af1427dc4d45d36e490f2e8a0e77c0de8bef22f55c8f52f5cf30"
    sha256 cellar: :any_skip_relocation, sonoma:        "a301a6af436dfbc3f51ce31cf43977ef7fd3a017f3f68e587463dc89b96c8ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaf494c0631eeb8a2cd0dbf4ea9b7ecf392c99a4ebce9bdaf9912e228c4c48b3"
    sha256 cellar: :any,                 x86_64_linux:  "b1a0a3acbf02dacd1a9eae09ccf4bf6b125e6e3448ece8bf68b8c5338088d692"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end