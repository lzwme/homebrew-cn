class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.9.6.tar.gz"
  sha256 "024cee0a5af4130723eeb00be8f7d38434e68d62a430d61eb4bcb0536ea87122"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c4fa95cf1b36505d94e430819b54961f96cdef4acbbdcc491cd5ce5e81a9f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eebe25404ea1d1fe9a839dd626b45c1b98c0578930099d45aa34fd53ebc3f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b01efb87d8962e669c99ff882d54ffb5e4dbf6ed76d5e8397f35434ead34fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b17add447f019b0b3796e4fece3d02145fde0bfec8070e51603ba4b3f1a44d0"
    sha256 cellar: :any_skip_relocation, ventura:       "8f61050521245cb94787d012aeb16a0e0680460df5c3732b162b0e84d14e1159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d2d242fae6af8c65c4ff163b995ae10d346e7fb07fe0d879ad1199fee97b74"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end