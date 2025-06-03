class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.11.0.tar.gz"
  sha256 "92141dd13b8dbe279abb3b3ef89ee15e7a960a17b2da18e9a7d079f1552e47a7"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d70331a6698910a6a8006bfad201efe7a3b02acf3d3de369db2f48de04a9d6df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7590e2cb41cdc66c4884357223d5754b02a102b951602b35d2eef31ca45b1da2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "477c228774a90c3bfd3d5b471ed87fe5a880449d1a7634d2e07f784a9f57617e"
    sha256 cellar: :any_skip_relocation, sonoma:        "05580f71852ed30b2849daf2373d9c8fa5accd3e28f9c942f7449abfc8abecac"
    sha256 cellar: :any_skip_relocation, ventura:       "882356880e346fbae520d846c5fb54183eec8c4538368082a3fc1ce4c88f1a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15f95a08d37f63afeb59dde6d4b5d652ed193bfd7eef18d2b2b07320d3c9ac0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b5786dab8770c9f7200dec51b7edb8e58ab594b4ae05ab3287d52076d7044b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end