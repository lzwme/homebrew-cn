class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https:github.comfalcosecurityfalcoctl"
  url "https:github.comfalcosecurityfalcoctlarchiverefstagsv0.7.1.tar.gz"
  sha256 "f280bba878dd32e35a552fb9667df1b14f0871e334f9f7832aec61f037bab8df"
  license "Apache-2.0"
  head "https:github.comfalcosecurityfalcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daad84eb52ab629b36ccd16c213add7204d29d8d56f2cccb6c9bac139560a5d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3c09433daf16ec589f7f57ad008e2bcd3dca4ee7c61e38b594851aee10999c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b1939e6f636c23e084ee8cc2db8b0e6d0260b22ca6a9e3fed44b3eca224f2c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf9e07384efd88fd3b86b4be33de1eb57517013ac44575b00fd7e4dd54472a6d"
    sha256 cellar: :any_skip_relocation, ventura:        "6fff3875a59bb4bdaa15646e25687e3e649429580d0a22783e42e93fd4b8e140"
    sha256 cellar: :any_skip_relocation, monterey:       "6816aaf206f654d5f49b0d92b1e26556192f55ac996ec5efaaef0e19724910bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e337ca1a2c0ca4360492e4c8aee8945275be6c064a1c97c367df8954f9f5658"
  end

  depends_on "go" => :build

  def install
    pkg = "github.comfalcosecurityfalcoctlcmdversion"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "."

    generate_completions_from_executable(bin"falcoctl", "completion")
  end

  test do
    system bin"falcoctl", "tls", "install"
    assert_predicate testpath"ca.crt", :exist?
    assert_predicate testpath"client.crt", :exist?

    assert_match version.to_s, shell_output(bin"falcoctl version")
  end
end