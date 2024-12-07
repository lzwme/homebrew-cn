class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.6.3.tar.gz"
  sha256 "533498a9915439b2ca61570f453b2079874378e0ae0a890a43fc1f9b3c587197"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e493e40cf5c7fac5155a69266f3e35d3558d2b474aeb82fb7407fb8bdf4ce55b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7788c8df239ed23fe32f761cde94063d4ca849619459d4bfbc8e8179708e3983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "796d230b4146d703a3adf3ebb724fbfec75680f83acd2ecce3c2fcdb1e53427a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ec67deafa67f1aa4a83431be9cb25f587b935cdd464bb8f37903406a195ecb7"
    sha256 cellar: :any_skip_relocation, ventura:       "cecf559db6fb852ac4f488d219cdd2bd248e4388d04c69d4a4e073d73beb805b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ba28ba537f4a339338f492d6b6867040742bfa12bb5e55dc4d796b4ddef2945"
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