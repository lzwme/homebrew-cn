class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https:cobalt-org.github.io"
  url "https:github.comcobalt-orgcobalt.rsarchiverefstagsv0.19.5.tar.gz"
  sha256 "ffd16cdd4cd3ff801584d54607934e5e9f42941b2206c12367f8a18c1015267a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3efbfc9532e3f74d987e19d484979595f6880fbdb6c08435a1aeb2e9cdf09a18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc3de2bd3082aa20295fb7daa40864acef003492a4b610ad9ba40d609078a414"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2cc00f4ad13549382cd15f5ee8e996881a85408e1c22ecaadd8295111698fa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaf758a83e78347290b3bf5a6781683fa6fecb470a9b8b7d8d760073cc5f5702"
    sha256 cellar: :any_skip_relocation, ventura:        "151ff84806b6331e06f380c32fbe1e89ce01dfd10c40ed0ce0b5764ba3e91d3d"
    sha256 cellar: :any_skip_relocation, monterey:       "fc681dc5f9c90a956ea871583bebd2828fbb552a598f36ab3f63ee61a8a53ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0af2c93c4df9ebec24fb4ea004fa9453dd0412d2cb8da60b3a77b115549c8320"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"cobalt", "init"
    system bin"cobalt", "build"
    assert_predicate testpath"_siteindex.html", :exist?
  end
end