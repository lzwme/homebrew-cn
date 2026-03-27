class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "c5130eac44b0f26699f7ab9afc8fac215962ad1e537a3988fe053f82c5775344"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce6806fa497bc8d17d798ef68c92a20bb0bd7cb8ab9cce5180e4e0f5fda19ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d9878be67a0d80b294dfbb4f3a5f164742cb6766c3e5f8149868eddada5989c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e814f1f3e9f52eedd6dcbff1166b18d98d2318833b7645b7e5e358ba174bbd26"
    sha256 cellar: :any_skip_relocation, sonoma:        "29703c47db4e9f6dbe6d692f65850c83e7f596e98d1ee7955d9d420915f5374f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ebba9c43d4dda0d1a0432dd299045e790c9213baecbd579f54b8fb19c4b3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5380a8cbea3e6c15c25b7f9a3f7f4531cdebd6819749f0e0d78818878e04067e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end