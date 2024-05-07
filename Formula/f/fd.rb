class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https:github.comsharkdpfd"
  url "https:github.comsharkdpfdarchiverefstagsv10.0.0.tar.gz"
  sha256 "a8e95bf363dc70896f5404bf7b0ab10f7d5e98a13485369e0dfd6579bf461a05"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsharkdpfd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10d84be18e2dffa9bffe4062a967daafade8fe7725ce07cf1f12bb303cebb49e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fc0340fa6eee4ca742361f9aacadddd82d3f629833990503a5173aee9a852db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e2660c197b9e8de65b452179e50810efc5a4d3021bb2a5f59154ec5ef825ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "d04890eae56ecb35b17a7e36a3d9a58b8644b3972322067ac35d2703a981d06a"
    sha256 cellar: :any_skip_relocation, ventura:        "01f2b28a838ab445f63beaee199db006c0cbd56ad40756ecb947eaf0c5035eff"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf7498d65d68eafb533b5f716935360d56a32535fd32223053eaad16a0af79b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e2566c5225494852e954f2c1f0dabb8b284f9892bc50f837812ae19171f1926"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docfd.1"
    generate_completions_from_executable(bin"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contribcompletion_fd"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https:github.comclap-rsclapissues5190
    (share"bash-completioncompletions").install bash_completion.children
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}fd test").chomp
  end
end