class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.7.1.tar.gz"
  sha256 "06d354a5cc143b5333e6c09b019f71c8583f02f98e2864af88c6362691e1f446"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b958eaf4d3936b2fabbc9364c45b6e1d33746b43cad0bd1e9a33144ce0c57975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd96218194d3dcaadcf3c8b7c10752625d179480fa33076be0e351b318ef156"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "320a7e0a4c775d359bc6e0559d402fc8e3317d8b8e325d70f9a6e050e6c5aea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9153799ea00afcc85a267134437fb15c66a24356647b8a77dc57d690224d1962"
    sha256 cellar: :any_skip_relocation, ventura:       "47616a87b65d2815f46eacac64e84e957a5acaff40934db6ef992912d3544702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e635bfe0aa0d994d0f34b87f8217960b83610030b7147b562f05b73b39708be5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https:github.comcurlpipeoxissues178 for discussions
    assert_match version.to_s, shell_output("#{bin}ox --version")
  end
end