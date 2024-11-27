class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.6.2.tar.gz"
  sha256 "12db37408b69ef224d7d77fa6e7422124f6e8956419c48202de41ce182fb075d"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f1ebbd321004ed971ee828cdf31928c2e2cb41da0a1912afeff51b565cebfbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2803f9ebc81e8a22924e40a9a51ef28de2cdfc5923ed2a59962b8c98303c4e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "815b6e87316c7baadce2a0193bcae9c97efb2c709822b1f78b3190988aa3837b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7ef37f36a951b55670ba73c701298db2991e60cb04e2f821995d7c4453dc43"
    sha256 cellar: :any_skip_relocation, ventura:       "4a11c45ce048f22089ef6cfcee533b1ad19dd02ac5983f35c4662d238cdfc80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f61a5e3a6c7f504ec9369cbbaef5698d1037d895d22245d215e3f1a73afdcf0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end