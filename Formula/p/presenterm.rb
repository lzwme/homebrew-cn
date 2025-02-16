class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https:github.commfontaninipresenterm"
  url "https:github.commfontaninipresentermarchiverefstagsv0.10.1.tar.gz"
  sha256 "59e7a90731777f9f9dd9823501869c8d6389a6c8f78d09cfbc9c85c39e69a14e"
  license "BSD-2-Clause"
  head "https:github.commfontaninipresenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e350ec9bf4fd6d3c1a808712a81de15f04df39c2f80bbfa5138080961b11c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0117ac5b6aeb1f10e8d93eea02b8e5eeaf309ead2df0a850cebd07e7183996bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbf0c914113e045b3d219628b1be1f19c4af016b371189d568f55a1b42b6b046"
    sha256 cellar: :any_skip_relocation, sonoma:        "20fc2bf1e9ecbdfe22e79714deb936a6d05b74adb69052540eb948e30410dde2"
    sha256 cellar: :any_skip_relocation, ventura:       "3c82a63bdac4c06ddd1d516681be6532b325cc79956ccac9d94a20404c3dd3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68576dcea4e9b46c2dd4d8b07e109954c01858d29cb298a68493a8c513091dd4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}presenterm --version")
  end
end