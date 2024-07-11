class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.3.1.tar.gz"
  sha256 "ad8b74c80373b6f80f2a6e8182441b972e2c70136dfb17befa2fb105f32868ad"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f08c9382f2d268efc165e73c1ff7fb776fda82bf39793bfdd9e086cdc3da3d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99a68093ba5da20e29296f0826e8c28da19b6a875a1ecaceb6b547be7468c87f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c18a96fa332ff86f5d38b8cd1100375af40ee1b353542afd14d831a65a6159aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e89d4e83c49358ea10fabdf9da7a92aa99b9632b23d30acab3c52f7b9124654"
    sha256 cellar: :any_skip_relocation, ventura:        "c38f33204619bd7cb27d610c79591a8be1ffab8b24d7acf8e26086a741658ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "8566e174e4637fb1e506af9bf14e2275043cbeb8711a6bf47975e1e1edaddab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a73bed2c2c5f09dfa970128004b795262a2a1e2daa30bc1a2bc12bf2ab497945"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end